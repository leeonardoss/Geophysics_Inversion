#Leonardo Budhi Satrio Utomo
#12318011

import numpy as np
import matplotlib.pyplot as plt

#Parameter Model
x = np.array([200,550,750,500,900]) #m
y = np.array([400,200,700,900,500]) #m
z = np.array([100,200,130,180,150]) #m
R = np.array([110,125,110,105,100]) #m
rho = np.array([2630,3150,3040,2700,2450]) #kg/m^3

x0 = np.linspace(min(x)-200,max(x)+200,100)
y0 = np.linspace(min(y)-200,max(y)+200,100)
[x_grid,y_grid] = np.meshgrid(x0,y0)
[m,n] = x_grid.shape

x_grid_reshape = x_grid.reshape([m*n,1])
y_grid_reshape = y_grid.reshape([m*n,1])

#Matriks Kernel G
G = np.zeros([m*n,len(rho)])
for i in range(0,len(x_grid_reshape)):
    for j in range(0,len(rho)):
        G[i,j]+= 6.674*(10**(-11))*((4/3)*np.pi*R[j]**3*z[j])/(((x_grid_reshape[i]-x[j])**2+(y_grid_reshape[i]-y[j])**2+z[j]**2)**(3/2))*10**5

d = np.dot(G,rho)
d_noise = d+np.random.randn(len(d))*0.5

#Inversi
rho_inv = np.dot(np.dot(np.linalg.inv(np.dot(np.transpose(G),G)),np.transpose(G)),d_noise)

d_inv = np.dot(G,rho_inv)

Erms = np.sqrt(1/(m*n)*sum((d_noise-d_inv)**2))
print("Erms:",Erms)

d_noise_plot = np.reshape(d_noise,[m,n])
d_inv_plot = np.reshape(d_inv,[m,n])

fig,axes = plt.subplots(nrows=1,ncols=2,figsize = [12,8])
axes[0].set_xlabel('X (m)', fontsize=12)
axes[0].set_ylabel('Y (m)', fontsize=12)
axes[0].set_title('Nilai Gravitasi dengan Noise')
axes[0].contourf(x_grid,y_grid,d_noise_plot,cmap="gnuplot2")


axes[1].set_xlabel('X (m)', fontsize=12)
axes[1].set_ylabel('Y (m)', fontsize=12)
axes[1].set_title('Nilai Gravitasi hasil inversi')
p = axes[1].contourf(x_grid,y_grid,d_inv_plot, cmap="gnuplot2")

fig.colorbar(p,label='Gravity(mGal)')

i=0
while i<len(rho_inv):
    print("Rho calculated ", i+1,"= ", rho_inv[i])
    i= i + 1
plt.show()







