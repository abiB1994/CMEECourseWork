import networkx as nx
import csv
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy as sc

links = "../Data/QMEE_Net_Mat_edges.csv"
nodes = "../Data/QMEE_Net_Mat_nodes.csv"


def getdata(f):
    """This function reads the data into a dataframe"""
    df = pd.read_csv(f)
    return df

links = getdata(links)		#link dataframe
node = getdata(nodes)		#node df
links.loc[:, "id"] = links.columns
melted = pd.melt(links, id_vars=["id"])			#Lining up the matrices with 
edges = melted.apply(tuple, axis =1)		#creating tuples for edge input									# 'interactions' and value


print edges
print node


#~ G = nx.from_pandas_dataframe(links, links.columns[1], links.columns[2],links.columns[3])
pos = nx.circular_layout(node.loc[:,"id"]) #Creating a circular network
G = nx.DiGraph()
G.add_nodes_from(node["id"])
for (u, v, w) in edges:
	G.add_edge(u, v, weight = w)
nx.draw_networkx(G, pos)
edge_labels = dict([((u,v),d["weight"]) for u,v,d in G.edges(data=True)])
nx.draw_networkx_edge_labels(G, pos, edge_labels = edge_labels)
G = nx.relabel_nodes(G,node["id"])
print G["ICL"]["CEH"]["weight"]
#~ plt.gca().set_position([0, 0, 1, 1])

plt.show() 
plt.savefig("../Results/test.svg")
