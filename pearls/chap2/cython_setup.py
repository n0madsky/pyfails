from distutils.core import setup
from Cython.Build import cythonize

setup(
  name = 'Array Swaps',
  ext_modules = cythonize("swap.pyx", compiler_directives={"cdivision": True}),
)