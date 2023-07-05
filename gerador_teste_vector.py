import random
from sys import maxsize

def binary_operation(A, B, size, mode):
    if size == "00":
        group_size = 4
        num_groups = 8
    elif size == "01":
        group_size = 8
        num_groups = 4
    elif size == "10":
        group_size = 16
        num_groups = 2
    elif size == "11":
        group_size = 32
        num_groups = 1
    
    A = int(A, 2)
    B = int(B, 2)
    result = []
    
    for _ in range(num_groups):
        group_A = A & ((1 << group_size) - 1)
        group_B = B & ((1 << group_size) - 1)
        
        if mode == 0:
            group_result = (group_A + group_B) & ((1 << group_size) - 1)
        elif mode == 1:
            group_result = (group_A - group_B) & ((1 << group_size) - 1)
        
        result.append(format(group_result, f"0{group_size}b").zfill(group_size))
        
        A >>= group_size
        B >>= group_size
    
    result.reverse()
    return result

def int_to_binary(value):
    binary = format(value & 0xFFFFFFFF, "032b")
    return binary

def generate_size():
    size_values = ["00", "01", "10", "11"]
    return random.choice(size_values)

def generate_mode():
    return random.randint(0, 1)


with open("teste_vector_somador.txt", "w") as f:
    f.write("# Test vector for somador_vetorial\n\n")
    f.write("A[32] B[32] mode size[2] resultado[32]\n")

    for _ in range(1000):
        a = int_to_binary(random.randint(0, maxsize//8))
        b = int_to_binary(random.randint(0, maxsize//8))
        size = generate_size()
        mode = generate_mode()

        resultado_list = binary_operation(a, b, size, mode)

        resultado = "".join(resultado_list)

        print(f"{a} {b} {mode} {size} {resultado}\n")
        f.write(f"{a} {b} {mode} {size} {resultado}\n")