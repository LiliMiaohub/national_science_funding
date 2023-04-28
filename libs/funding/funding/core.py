from matplotlib import gridspec
from mpl_toolkits.axes_grid1 import make_axes_locatable
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
import seaborn as sns
import matplotlib.pyplot as plt
import geopandas as gp
import pandas as pd
from adjustText import adjust_text
import networkx as nx
import numpy as np
from scipy import integrate

def read_geofile(path):
    """read sh file and return the file without Antarctica
    """
    world_geo=gp.read_file(path)
    world_geo=world_geo[['WoS','Code','geometry']]
    world_geo=world_geo[world_geo.WoS!='Antarctica']
    return world_geo

def plot_worldmap(ax, fig, basemap, data, plotcolumn, cmap, vmin, vmax):
    """plot a basemap and color the country based on the column passed into
    """

    basemap.plot(ax=ax, linewidth=0.25, edgecolor="#8C8C8C", facecolor="#ffffff")
    data.plot(column=plotcolumn, cmap=cmap, vmin=vmin, vmax=vmax, ax=ax)
    ax.axis("off")

    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="2%", pad=0.05)
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=plt.Normalize(vmin=vmin, vmax=vmax))
    sm._A = []
    clb = fig.colorbar(sm, cax=cax)
    clb.ax.set_title("")

    return fig, ax

def group_wide(df):
    """this function  groups dataframe by country and return the wide format with row normalization
    """
    df=df.groupby(['cntry','dis'])['count'].sum().reset_index()
    df=df.pivot_table(index='cntry',columns='dis',values='count',fill_value=0)
    df=df.div(df.sum(axis=1), axis=0)
    return df

def sort_matrix(df1,df2):
    """this function sort two matrix with the same order of column list
    """
    dislist=df1.columns
    df1=df1[dislist]
    df2=df2[dislist]
    return df1, df2

def select_topn(df,groupby,colname,year,n):
    """this function selects the topn country based on the value on the 'year'
    """
    topndf = df[df.year==year].groupby(
        [groupby])[colname].mean().sort_values(ascending=False).head(n)
    return topndf.index,topndf.values

def get_palette():
    path='/u/miaoli/ember_home/funding/NationalFunding/Data/AdditionalData/country_WoS_ECI_WB_flags.tsv'
    flag_df=pd.read_csv(path,sep='\t')[['WoS','Code']]
    flag_df=flag_df.drop_duplicates()
    palette = {k:'#D0D2F2' for k in flag_df.Code.unique()}
    palette['CHN']='#A6341B'
    palette['USA']='#F2506E'
    return palette

def plot(df,xcol,ycol,ax,topnlist,yvalues,ylabel):

    df = df[df.Code.isin(topnlist)]
    palette=get_palette()

    sns.lineplot(x=xcol,y=ycol,err_style='bars',ci=95,hue='Code',data=df,ax=ax,legend=False,palette=palette)
    vals = ax.get_yticks()
   # if "Percentage" in ylabel:
   #     ax.set_yticklabels(['{:,.2%}'.format(x) for x in vals])
    texts = [ax.text(2021, yvalues[i], topnlist[i]) for i in range(len(topnlist))]
    adjust_text(texts, arrowprops=dict(arrowstyle='->'),ax=ax)
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.tick_params(axis='both', which='major', labelsize=12)
    ax.set_ylabel(ylabel,fontsize=12)
    ax.set_xlabel("")
    return ax

'''
This module implements the disparity filter to compute a significance score of edge weights in networks
The script comes from https://github.com/aekpalakorn/python-backbone-network
'''



def disparity_filter(G, weight='weight'):
    ''' Compute significance scores (alpha) for weighted edges in G as defined in Serrano et al. 2009
        Args
            G: Weighted NetworkX graph
        Returns
            Weighted graph with a significance score (alpha) assigned to each edge
        References
            M. A. Serrano et al. (2009) Extracting the Multiscale backbone of complex weighted networks. PNAS, 106:16, pp. 6483-6488.
    '''
    
    if nx.is_directed(G): #directed case    
        N = nx.DiGraph()
        for u in G:
            
            k_out = G.out_degree(u)
            k_in = G.in_degree(u)
            
            if k_out > 1:
                sum_w_out = sum(np.absolute(G[u][v][weight]) for v in G.successors(u))
                for v in G.successors(u):
                    w = G[u][v][weight]
                    p_ij_out = float(np.absolute(w))/sum_w_out
                    alpha_ij_out = 1 - (k_out-1) * integrate.quad(lambda x: (1-x)**(k_out-2), 0, p_ij_out)[0]
                    N.add_edge(u, v, weight = w, alpha_out=float('%.4f' % alpha_ij_out))
                    
            #elif k_out == 1 and G.in_degree(G.successors(u)[0]) == 1:
            elif k_out == 1 and G.in_degree(G.successors(u)) == 1:
                #we need to keep the connection as it is the only way to maintain the connectivity of the network
                #v = G.successors(u)[0]
                v = G.successors(u)
                w = G[u][v][weight]
                N.add_edge(u, v, weight = w, alpha_out=0., alpha_in=0.)
                #there is no need to do the same for the k_in, since the link is built already from the tail
            
            if k_in > 1:
                sum_w_in = sum(np.absolute(G[v][u][weight]) for v in G.predecessors(u))
                for v in G.predecessors(u):
                    w = G[v][u][weight]
                    p_ij_in = float(np.absolute(w))/sum_w_in
                    alpha_ij_in = 1 - (k_in-1) * integrate.quad(lambda x: (1-x)**(k_in-2), 0, p_ij_in)[0]
                    N.add_edge(v, u, weight = w, alpha_in=float('%.4f' % alpha_ij_in))
        return N
    
    else: #undirected case
        B = nx.Graph()
        for u in G:
            k = len(G[u])
            if k > 1:
                sum_w = sum(np.absolute(G[u][v][weight]) for v in G[u])
                for v in G[u]:
                    w = G[u][v][weight]
                    p_ij = float(np.absolute(w))/sum_w
                    alpha_ij = 1 - (k-1) * integrate.quad(lambda x: (1-x)**(k-2), 0, p_ij)[0]
                    B.add_edge(u, v, weight = w, alpha=float('%.4f' % alpha_ij))
        return B
