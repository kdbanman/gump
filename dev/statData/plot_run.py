import os
import numpy
import matplotlib

matplotlib.use('Agg')
import matplotlib.pyplot as plt

def read_memmap(filename):
  return numpy.memmap(filename, dtype=numpy.int32, mode='r')

def create_memmap(csv_filename, binary_filename):
  csv_line_count = sum(1 for line in open(csv_filename))
  data = numpy.memmap(binary_filename, dtype=numpy.int32, mode='w+', shape=(csv_line_count))

  for line_number, line in enumerate(open(csv_filename)):
    try:
      _generation, population = list(map(int, line.split(',')))
      if not numpy.isfinite(population):
        print("Could not parse line {} with population {}.".format(line_number, population))
        print("-1 population recorded.")
        population = -1
      data[line_number] = population
    except:
      print("Could not extract line {}.".format(line_number))
      print("-1 population recorded.")
      data[line_number] = -1

  return data

def plot_run(run_name, dpi):
  input_filename = run_name + '.csv'
  binary_filename = run_name + '.dat'
  output_filename = run_name + '_' + str(dpi) + 'DPI.png'

  if os.path.exists(binary_filename):
    print("Opening existing memmap.")
    data = read_memmap(binary_filename)
  else:
    print("Creating new memmap.")
    data = create_memmap(input_filename, binary_filename)

  print("Plotting population graph.")
  plt.plot(data, 'r,')
  plt.grid(True)
  plt.title("Population Over Time")
  plt.xlabel("Generation")
  plt.ylabel("Population")
  plt.savefig(output_filename, dpi=dpi)

  data._mmap.close()
  del data

plot_run('population_2018-10-03-08-32', 500)
