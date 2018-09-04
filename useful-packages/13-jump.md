# 13 - JuMP

JuMP is an algebraic modelling language for mathematical optimisation problems, similar to GAMS, AMPL or Pyomo.

It is solver-independent. It supports also non-linear solvers, providing them with the Gradient and the Hessian.

The following notebook provides a commented implementation in JuMP ocf the classical transport problem found in the GAMS tutorial:

{% embed data="{\"url\":\"http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/JuMP.ipynb\",\"type\":\"link\",\"title\":\"Notebook on nbviewer\",\"description\":\"Check out this Jupyter notebook!\",\"icon\":{\"type\":\"icon\",\"url\":\"http://nbviewer.jupyter.org/static/ico/apple-touch-icon-144-precomposed.png?v=5a3c9ede93e2a8b8ea9e3f8f3da1a905\",\"width\":144,\"height\":144,\"aspectRatio\":1},\"thumbnail\":{\"type\":\"thumbnail\",\"url\":\"http://ipython.org/ipython-doc/dev/\_images/ipynb\_icon\_128x128.png\",\"width\":128,\"height\":128,\"aspectRatio\":1}}" %}

Note: While JuMP seems to work in Julia 0.7/1.0, many solver interfaces \(including the ones used in the above notebook\) don't jet work with Julia versions above 0.6.

