import os 
import glob

dir_path = os.path.dirname(os.path.realpath(__file__))
directories = [x[0] for x in os.walk(dir_path)]
clean_dirs = []
count = 0

for directory in directories:
	clean_dirs.append(glob.glob(directory + "/*.lua"))

for directory in clean_dirs:
	if len(directory) > 0:
		if len(directory) > 1:
			for dir in directory:
				with open(dir, "r") as f:
					for line in f.readlines():
						count += 1
		else:
			with open(directory[0], "r") as f:
				for line in f.readlines():
					count += 1

print(f"Line Count: {count}")