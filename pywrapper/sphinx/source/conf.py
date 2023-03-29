#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys, importlib.util
sys.path.insert(0, os.path.abspath('../../'))
cautodoc_root = os.path.abspath('../../')

# Import only version.py file for extracting the version
spec = importlib.util.spec_from_file_location('version', '../../pyiapws/version.py')
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)


# -- General configuration ------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#
# needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ['sphinx.ext.autodoc', 'sphinx.ext.doctest', 'sphinx.ext.intersphinx',
              'sphinx.ext.todo', 'sphinx.ext.coverage', 'sphinx.ext.imgmath',
              'sphinx.ext.ifconfig', 'sphinx.ext.viewcode','numpydoc']

#breathe_default_project = mod.__package_name__
#breathe_projects = {mod.__package_name__: "../doxygen/xml/"}
# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
#
# source_suffix = ['.rst', '.md']
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = mod.__package_name__
copyright = mod.__copyright__
author = mod.__author__

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = mod.__version__
# The full version, including alpha/beta/rc tags.
release = version

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = 'en'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This patterns also effect to html_static_path and html_extra_path
exclude_patterns = []

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = False


# -- Options for HTML output ----------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'classic'

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#
html_theme_options = {}
# html_theme_path = []

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
# html_static_path = []


# -- Options for HTMLHelp output ------------------------------------------

# Output file base name for HTML help builder.
htmlhelp_basename = mod.__package_name__


# -- Options for LaTeX output ---------------------------------------------

latex_elements = {
    # The paper size ('letterpaper' or 'a4paper').
    #'engine': 'pdflatex',
    'papersize': 'a4paper',

    # The font size ('10pt', '11pt' or '12pt').
    #
    'pointsize': '10pt',

    # Additional stuff for the LaTeX preamble.
    #
    'preamble': r"""\DeclareUnicodeCharacter{2212}{-}""",

    # Latex figure (float) alignment
    #
    'figure_align': 'htbp',
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
    (master_doc, 'pyiapws.tex', 'pyiapws Documentation',
     'M. Skocic', 'manual'),
]


# -- Options for manual page output ---------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, 'pyiapws Demonstration', 'pyiapws Demonstration Documentation',
     [author], 1)
]


# -- Options for Texinfo output -------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
    (master_doc, 'pyiapws Demonstration', 'C Extensiion Demonstration Documentation',
     author, 'pyiapws Demonstration', 'One line description of project.',
     'Miscellaneous'),
]


# Example configuration for intersphinx: refer to the Python standard library.
intersphinx_mapping = {'python': ('https://docs.python.org', None),
                       'numpy': ('https://docs.scipy.org/doc/numpy', None),
                       'scipy': ('https://docs.scipy.org/doc/scipy/reference', None)}


# autodoc_member_order = 'groupwise'

numpy_show_class_members = True
numpydoc_show_inherited_class_members = False

autoclass_content = 'init'  # PEP257 indicates that classes should be documented in __init__