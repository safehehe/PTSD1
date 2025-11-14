mono_path = "./mono.hex"
def decimal_to_byte(decimal):
    hex_by = f'{decimal:02x}'
    return hex_by

bytes_colors = []

for i in range(4096):
    if i > (64*31-1) :
        bytes_colors.append(decimal_to_byte(3))
    else :
        bytes_colors.append(decimal_to_byte(10))

with open(mono_path,'w') as f:
    f.write("\n".join(bytes_colors))
print("Generada paleta en hex en:",mono_path)