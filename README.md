# SanePascal
Sane (libsane) features for Free Pascal and Delphi

# Installation

SanePascal is a runtime library. There are no visual components that have to be installed. 
Just add the package to dependancy/required of your Lazarus/Delphi Application and start using it.

The library, created by Massimo Magnano (2025), is based on an old one written by Malcolm Poole(2008).

# Library design

- SanePascal is not a TComponent descendand. 
  You have to use it from code only and free it by yourself (see the examples).
  For Lazarus use SanePascal_pkg.lpk package, 
  For Delphi use SanePascal_dpkg.dpk package,
- Supported Compilers:
  Lazarus / Free Pascal
  Delphi  (theoretically it is compatible but it needs to be tested)

See the changelog.txt file for Change Log

(c) 2025 Massimo Magnano
