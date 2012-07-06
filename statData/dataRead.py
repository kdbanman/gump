data[]

count = 0

file = open('runData16by16allON.txt')
for line in file:
    generation, alive = line.split()
    data.append(alive)
    count = count + 1

    if count%100 = 0:
        print(data[count-1])
