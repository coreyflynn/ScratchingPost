import cmap.analytics.sc as sc
import matplotlib.pyplot as plt
import numpy as np
import itertools


def plot_ROC(brew_dirs,brew_base):
    sco = sc.SC()
    
    for d in brew_dirs:
        sco.add_sc_from_brew(d, brew_base, 'by_rna_well')
    
    sco.dedup_perts(exclude='DMSO')
    
    FPR = [1]
    TPR = [1]
    for i in np.linspace(0.1, 0.9, 9).tolist():
        sco.set_thresh_by_specificity(i, control='DMSO')
        FPR.append(1-sco.get_specificity())
        TPR.append(sco.get_sensitivity())
    FPR.append(0)
    TPR.append(0)    
    
    plt.plot(FPR,TPR)
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.xlim([0,1])
    plt.ylim([0,1])

brew_base = '/xchip/cogs/data/brew/new/'

brew_pool = ['CPC006_A549_6H',
             'CPC006_MCF7_6H',
             'CPC006_PC3_6H']

plot_ROC(brew_pool,brew_base)

ones = list(itertools.combinations(brew_pool,1))
twos = list(itertools.combinations(brew_pool,2))
for x in ones:
    plot_ROC(list(x),brew_base)
for x in twos:
    plot_ROC(list(x),brew_base)
plot_ROC(brew_pool,brew_base)
plt.show()
