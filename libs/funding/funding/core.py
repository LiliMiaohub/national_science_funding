from matplotlib import gridspec
from mpl_toolkits.axes_grid1 import make_axes_locatable
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
import seaborn as sns
import matplotlib.pyplot as plt
import geopandas as gp
import pandas as pd
from adjustText import adjust_text

def read_geofile(path):
    """read sh file and return the file without Antarctica
    """
    world_geo=gp.read_file(path)
    world_geo=world_geo[['WoS','Code','geometry']]
    world_geo=world_geo[world_geo.WoS!='Antarctica']
    return world_geo

def plot_worldmap(ax, fig, basemap, data, plotcolumn, cmap, vmin, vmax,legend_title):
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
    clb.ax.set_title(legend_title)

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
