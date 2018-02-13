import sys
import codecs

def encode():
  path = "/Users/user/Documents/Class_Notes/COURSERA/Bayesian_Stats/project"
  basename = "data.csv"
  filename = path + "/" + basename
  #file = open(filename, "rt")
  f = codecs.open(filename,encoding='utf-8')
  contents = f.read()


  print contents ,"\n"
  newcontents = contents.replace('B','M').replace('0', '1')

  print newcontents


  f.close()

path = "/Users/user/Documents/Class_Notes/COURSERA/Bayesian_Stats/project"
basename = "data.csv"
filename = path + "/" + basename

with open(filename, 'r') as file :
  filedata = file.read()

# Replace the target string
filedata = filedata.replace('M', '1')
filedata = filedata.replace('B', '0')

# Write the file out again
with open('newdata.csv', 'w') as file:
  file.write(filedata)
