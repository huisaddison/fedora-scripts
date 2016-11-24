#! /usr/bin/python3
from argparse import ArgumentParser
from markdown import markdown
from sys import argv
from textwrap import dedent
from warnings import warn

default_stylesheet = '/home/addison/utils/templates/style.css'

parser = ArgumentParser(description=dedent(
        '''Wrapper around Python Markdown to compile markdown
           files to HTML, with options for linking to a style
           sheet and Javascript libraries for syntax highlighting
           and mathematical formula rendering.
           '''))
parser.add_argument('--stylesheet', dest='stylesheet', metavar='./style.css',
        default=default_stylesheet, help='style sheet')
parser.add_argument('--no-syntax-highlighting', dest='no_highlight',
        action='store_const', const=True, default=False,
        help='turn off syntax highlighting')
parser.add_argument('--no-mathjax', dest='no_mathjax',
        action='store_const', const=True, default=False,
        help='turn off MathJax support')
parser.add_argument('input_files', metavar='input.md', nargs='+',
        help='input markdown files')

args = parser.parse_args(argv[1:])

top = '''
<html>
<head>
<link href='https://fonts.googleapis.com/css?family=Lora&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
'''
mathjax_scripts = '''
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  tex2jax: {inlineMath: [['$','$']]}
});
</script>
<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_CHTML">
</script>
<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_CHTML">
  </script>
'''
highlighting_scripts = '''
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.5.0/styles/default.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.5.0/highlight.min.js"></script>
  <script>hljs.initHighlightingOnLoad();</script>
'''

github_img = '''<a href="https://github.com/huisaddison">
  <img style="float: right; position: relative; top: -20px; right: -20px"
       src="https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67"
       alt="Fork me on GitHub"
       data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png">
</a>
'''

for input_file in args.input_files:
    try:
        with open(input_file, 'rt') as infile:
            if input_file.endswith('.md'):
                outfile = input_file.replace('.md', '.html')
            else:
                warn(
                '''\n
                {0} lacks `.md` file extension.
                Output file will be named {0}{1}.
                '''.format(infile, '.html'), UserWarning)
                outfile = ''.join([infile, '.html'])
            with open(outfile, 'wt') as f:
                f.write(top)
                if not args.no_mathjax:
                    f.write(mathjax_scripts)
                if not args.no_highlight:
                    f.write(highlighting_scripts)
                if args.stylesheet:
                    f.write('<link rel="Stylesheet"')
                    f.write('type="text/css" href="{}">\n'.format(args.stylesheet))
                f.write('</head>\n')
                f.write('<body>\n')
                f.write(github_img)
                f.write(markdown(infile.read(), ['markdown.extensions.extra']))
                f.write('\n')
                f.write('</body>\n')
                f.write('</html>\n')
    except FileNotFoundError as e:
        print(e, '; skipping')
