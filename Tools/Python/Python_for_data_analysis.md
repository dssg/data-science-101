
#Python for Data Analysis: Lighting the Python Spark with a Little Energy Data

##Background

###What is Python?

[Python](https://www.python.org/) is a dynamically typed interpreted language with a fantastic and active user community, [distinctive culture](http://blog.startifact.com/posts/older/what-is-pythonic.html), and [loads of online resources.](https://wiki.python.org/moin/BeginnersGuide/Programmers)

###Why Python for Data Science?

As a general-purpose, high-level programming language, Python is a great language for getting just about anything you need to get done done. It has a simple, intuitive syntax that makes python programs easy to write and easy to understand.

For data scientists, it especially excels in data extraction, data cleaning, and has some of the most widely used libraries in scientific computing. 

Python, unlike R, didn't start out with statistics in mind. As a results, for data exploration and statistical analysis, there are still some room to grow, but it's [catching up quickly](http://slendermeans.org/pages/will-it-python.html).

There are lots of great places to learn data analysis in python. Take a look at the DSSG Learning Resource Hackpad for some of the greatest hits, and make sure to add your own as you find them.

Okay, let's get started.

###Setup

For this tutorial, you'll need to install ipython, numpy, scipy, pandas, and sklearn.

The path of least resistence is to install [Anaconda](https://store.continuum.io/cshop/anaconda/), a great distribution of python that has most of what you'll need for the summer. 

If you already have python installed, installing new python libraries is as easy as `pip`. 

try `pip install pandas`

###The basics: 
Python is an interpreted language, which means your computer runs a program that interprets the code that you writes converts it into. Let's try it out.

`>>> print "Hello DSSG!"`

`Hello DSSG!`

`>>> 1 + 1 `

`2`

`import this`


###Making Python Interactive
That's great, but what if I'm lazy and want things like tab completion.

[IPython](http://ipython.org/) is a great tool created by friend of DSSG, Fernando Perez.  

###Making Python Interactive, Literate, and Beautiful

The terminal is powerful but ugly. The browser is beautiful but limited. If only we could combine the power of the terminal with the beauty of the browser. 

We can! Thanks to IPython Notebook. 

`ipython notebook --pylab=inline`

####IPython Notebook is great

To show you the power of iPython Notebook,I'm going to follow  

###Getting Started with Some Data Structures: Lists, Dictionaries, Arrays, Matricies, Series, and DataFrames

There are lots of great ways. In fact, one of the ways that people are pythonic are by smartly using data structures like tuples, lists, and dictionarys. Let's explore python data structures. You can follow along using the data structures notebook.


###Working with Data: Energy Use by Participants in the Chicago Neighborhood Energy Challenge



statsmodels uses [patsy](http://patsy.readthedocs.org/en/latest/), which is a great library for describing statistical models in python


###Statsmodels: a great statistical library
Patsy is smart and automatically treats strings as categorical variables. You can make categorical variables explicit by using 

Using Formulas

Statsmodels typically 

####Bonus featurs for IPython Notebook

- IPython 