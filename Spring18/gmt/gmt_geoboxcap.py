import gmt
import csv
import numpy as np

# Make the figure
fig = gmt.Figure()
fig.basemap(region=[335,347,54,68],projection='X6i', frame=True)

# Get the data
def get_dat(path):
	lines = []
	with open(path) as f:
	    reader = csv.reader(f, delimiter=" ")
	    for line in reader:
	        lines.append(line)
	f.close()
	return lines

def no_header_float(data):
	if len(data[1]) == 3:
		return [[float(a), float(b), float(c)] for [a, b, c] in data[1:]]
	elif len(data[1]) == 2:
		return [[float(a), float(b)] for [a, b] in data[1:]]

# path = '/Users/maxvonhippel/Documents/NASA/Matlab Scripts/Spring18/figures/maps/geoboxcap_iceland.dat'
# xyz = no_header_float(get_dat(path))

# Get the outline
path = '/Users/maxvonhippel/Documents/NASA/Matlab Scripts/Spring18/figures/maps/border_0.0_iceland.dat'
xy0 = no_header_float(get_dat(path))

# Draw the outline
x = np.array([x for [x, y] in xy0])
y = np.array([y for [x, y] in xy0])
fig.plot(x, y, G='white', W=True, A=True)

# Show the outline
fig.show(method='external')