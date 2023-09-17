import hashlib

# Function to calculate the RIPEMD-160 hash of a file
def calculate_ripemd160_hash(file_path):
    try:
        # Open the file in binary mode
        with open(file_path, 'rb') as file:
            # Read the file contents
            file_contents = file.read()

            # Calculate the RIPEMD-160 hash
            ripemd160_hash = hashlib.new('ripemd160')
            ripemd160_hash.update(file_contents)

            # Return the hash as a hexadecimal string
            return ripemd160_hash.hexdigest()
    except FileNotFoundError:
        return "File not found"
    except Exception as e:
        return str(e)

# Specify the path to your PNG file
file_path = r"Path to your file"

# Calculate and print the RIPEMD-160 hash
hash_result = calculate_ripemd160_hash(file_path)
if hash_result != "File not found":
    print("RIPEMD-160 Hash:", hash_result)
else:
    print(hash_result)
