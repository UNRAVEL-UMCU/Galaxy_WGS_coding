total_length = 0

with open("merged_bed_file.bed", "r") as f:
    for line in f:
        fields = line.strip().split("\t")
        if len(fields) < 3:
            continue  
        start = int(fields[1])
        end = int(fields[2])
        length = end - start
        total_length += length

print(total_length)
