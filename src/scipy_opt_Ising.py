import numpy as np
import scipy.optimize as so
import matplotlib.pyplot as plt
import torch

Nfeval = 1
fun_list = list()
final_H = []

def Ising_fun(x: np.ndarray, *args) -> np.ndarray:
    # coupling_factor = N * N, external_field = N * 1, X = N * 1
    assert len(args) == 4, f'length of args should be 3 but get {len(args)} now'
    coupling_factor, external_field, sample = args[0], args[1], args[2] 
    numofvar = coupling_factor.shape[0]
    # x_matrix = x[:,None] - x
    x_matrix = coupling_factor * (
        2 * x[:,None] * x[None, :] - np.tile(x, (numofvar, 1)).T - np.tile(x, (numofvar, 1)))
    # result = np.sum(-coupling_factor * np.cos(x_matrix)) - 1 * np.sum(np.cos(2 * x))
    result = -np.sum(x_matrix)
    return result

def callbackF(Xi):
    global Nfeval
    print (f'{Nfeval}   {Ising_fun(Xi, *args)}')
    fun_list.append(Ising_fun(Xi, *args).item())
    Nfeval += 1

def gen_grad_mask(seed: int, numofvars: int, sample: int) -> np.ndarray:
    np.random.seed(seed=seed)
    index = torch.randperm(numofvars)[:sample].tolist()
    mask = np.zeros(shape=[numofvars, 1])
    mask[index] = 1
    #TODO: Generate a mask for 64-dimensional input: [0, 0, 0, 0, 1, 0, ......, 0, 1, 0, 0]
    return mask

def stochastic_grad(x: np.ndarray, *args) -> np.ndarray:
    """
    description:
    """
    coupling_factor, external_field, sample, seed = args[0], args[1], args[2], args[3]
    X = torch.from_numpy(x)
    X.requires_grad_(True)
    numofvar = coupling_factor.shape[0]
    coupling_factor = torch.from_numpy(coupling_factor)
    external_field = torch.from_numpy(external_field)
    # TODO: calculate jacobian
    # x_matrix = X.unsqueeze(1) - X.unsqueeze(0)
    x_matrix = coupling_factor * (
        2 * X[:, None] * X[None, :] - torch.tile(X, (numofvar, 1)).T - torch.tile(X, (numofvar, 1)))

    x_matrix.requires_grad_(True)
    # Hamiltonian = torch.sum(-coupling_factor * x_matrix.cos()) - 1 * torch.sum((2 * X).cos())
    Hamiltonian = -torch.sum(x_matrix)

    grad = torch.autograd.grad(
                        outputs=Hamiltonian, 
                        inputs=X,
                        grad_outputs=None,
                        # create_graph=True,  #For higher-order derivatives
                        allow_unused=True,
    )[0].unsqueeze(-1)
    mask = gen_grad_mask(seed, x.shape[0], sample)

    if grad is not None:
        grad = (grad.detach().numpy() * mask).tolist()

    return grad

def validate_result(x: np.ndarray, coupling_factor: np.ndarray):
    numofvar = coupling_factor.shape[0]
    for i in range(x.shape[0]):
        # x[i] = x[i] % (2 * np.pi)
        if abs(x[i] - 1) <= abs(x[i]):
            x[i] = 1
        elif abs(x[i] - 1) >= abs(x[i]):
            x[i] = 0
        else:
            raise ValueError

    result = np.sum(coupling_factor * (
        2 * x[:, None] * x[None, :] - np.tile(x, (numofvar, 1)).T - np.tile(x, (numofvar, 1))))
    print(x.T)
    print(result)

def plot(sample: int):
    plt.figure(1)
    plt.plot(range(len(fun_list)), fun_list, label=f'GD-{sample}')
    plt.xlabel('Iteration')
    plt.ylabel('Hamiltonian')
    plt.legend()
    plt.show()

def solving_so(numofvar: int, coupling_factor: np.ndarray, s_ratio: float, seed: int):
    x0 = 2 * np.random.rand(numofvar) * np.pi
    x1 = np.random.rand(numofvar)
    x1.resize([numofvar,])
    sample = int(numofvar * s_ratio)
    bnds = ()
    for _ in range(numofvar):
        # bnds += ((0, 2 * np.pi),)
        bnds += ((0, 1),)

    external_field = np.ones(shape=[numofvar, 1])
    opt = {'maxiter':100 if s_ratio >= 1 else 200}
    global args
    args= (coupling_factor, external_field, sample, seed)

    result_1 = so.minimize(
        fun=Ising_fun, 
        x0=x0, 
        method='SLSQP',         # second-order methods
        jac= stochastic_grad,
        bounds=bnds, 
        args=args, 
        callback=callbackF,
        options=opt,
        tol=1e-100              # Stopping criteria
    )

    x_input_1 = np.array(result_1.x)

    validate_result(x_input_1, coupling_factor)
    final_H.append(fun_list[-1])
    return fun_list, result_1.nit 

def print_():
    print(final_H)
    plt.show()

