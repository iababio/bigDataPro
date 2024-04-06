centroids = [[0, 1111], [1, 2222]]

with open('Centroids.txt', 'w') as f:
    for item in centroids:
        f.write(f"{item[0]},{item[1]}\n")