import numpy as np
import torch
import matplotlib.pyplot as plt
from scipy_opt_Ising import solving_so, print_
# print(int(time.time_ns()))
seed_ = 42    # For small problem size
np.random.seed(seed_)
# torch.random.manual_seed(seed_)

def read_MaxCut_model(file_name: str = "max cut 12 5 2022 (Inst. of Max Cut gka1a_new)_Input.txt") -> np.ndarray:
    """
    Description: Read the graph from .txt files
    """
    with open(file_name, "r") as file:
        lines = file.readlines()[1:]
        data = []
        for line in lines:
            row = line.strip().split()
            data.append([int(x) for x in row])

    matrix = np.array(data)
    coupling_matrix =  np.zeros(shape=[51, 51])

    for i in range(matrix.shape[0]):
        coupling_matrix[matrix[i][0] - 1][matrix[i][1] - 1] = int(matrix[i][2])
    
    return coupling_matrix

numvar = 51     # Problem-specific, canbe found in .txt files
coupling_factor = read_MaxCut_model()
# Randomly generated coupling factors: primary test
# # coupling_factor = np.random.randn(numvar ** 2).reshape(numvar, numvar)
# # coupling_factor = np.triu(coupling_factor)
# # coupling_factor += coupling_factor.T - np.diag(coupling_factor.diagonal())

# coupling_factor = np.zeros(shape=[numvar, numvar])
# couple_mask = torch.randperm(n=numvar * numvar)[:1600].detach().tolist()
# coupling_factor.reshape(-1)[couple_mask] = 1
# coupling_factor.reshape(-1)[couple_mask[800:]] = -1
# coupling_factor = ().reshape(coupling_factor.shape)

fun_256, n256 = solving_so(numvar, coupling_factor=coupling_factor, s_ratio=1, seed=seed_)
fun_128, n128 = solving_so(numvar, coupling_factor=coupling_factor, s_ratio=0.5, seed=seed_)
fun_64, n64 = solving_so(numvar, coupling_factor=coupling_factor, s_ratio=0.25, seed=seed_)
fun, n32 = solving_so(numvar, coupling_factor=coupling_factor, s_ratio=0.125, seed=seed_)
# n256 = 0
print(n256, n128, n64, n32)
def plot():
    plt.figure(1)
    plt.plot(range(len(fun[: n256])), fun[:n256], label=f'GD-{1024}')
    plt.plot(range(len(fun[n256: n256 + n128])), fun[n256: n256 + n128], label=f'GD-{512}')
    plt.plot(range(len(fun[n256 + n128: n256 + n128 + n64])), fun[n256 + n128: n256 + n128 + n64], label=f'GD-{256}')
    plt.plot(range(len(fun[n256 + n128 + n64:])), fun[n256 + n128 + n64:], label=f'GD-{128}')
    plt.xlabel('Iteration')
    plt.ylabel('Hamiltonian')
    plt.legend()
    plt.show()

plot()
print_()
