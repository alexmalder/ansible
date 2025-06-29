# Open the file in read mode
with open('resolved.txt', 'r') as file:
    # Read all lines and strip any leading/trailing whitespace
    lines = [line.strip() for line in file.readlines()]

# Join the lines with a comma
result = ','.join(lines)

# Print the result
print(result)
