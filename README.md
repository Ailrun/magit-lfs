

# Magit LFS

[Git LFS](https://git-lfs.github.com/) for [Magit](https://github.com/magit/magit), glorious Git client for Emacs!

<div id="text-table-of-contents">
<ul>
<li><a href="#org412b721">1.1. Installation</a></li>
<li><a href="#org9f658a4">1.2. Magit Binding</a></li>
<li><a href="#orgd691b7d">1.3. Todo List</a></li>
</ul>
</div>


## Installation

1.  In your emacs setting file, initialize [melpa](https://github.com/melpa/melpa) package.
2.  Follows instruction for your package managing method.
    -   For `package.el`
        1.  Install magit and magit-lfs via `package-install` command.
        2.  Write following codes to your emacs setting file. (usually `.emacs` or `.emacs.d/init.el`)
            
                (require 'package)
                
                ;; package repository settings
                
                (package-initialize)
                
                ;; Settings ...
                
                (require 'magit)
                
                ;; Settings ...
                
                (require 'magit-lfs)
    
    -   For `use-package.el`
        1.  Install magit and load it.
        2.  Write following codes to your emacs setting file.
            
                (require 'package)
                (require 'use-package)
                
                ;; Settings ...
                
                (package-initialize)
                
                ;; After load magit
                
                (use-package magit-lfs
                     :ensure t
                     :pin melpa)
    
    -   For `req-package.el`
        1.  Write following codes to your emacs settings file.
            
                (require 'package)
                
                ;; Settings ...
                
                (package-initialize)
                
                ;; Settings ...
                
                (require 'req-package)
                
                ;; Settings ...
                
                (req-package magit-lfs
                  :loader :elpa
                  :pin melpa
                  :require (magit))


## Magit Binding

-   `&`
    Initial commands for magit-lfs.
    -   `f`
        git lfs fetch
    -   `F`
        git lfs Pull
    -   `i`
        git lfs install
    -   `P`
        git lfs push
    -   `U`
        git lfs update
    -   `!`
        git lfs fsck


## Todo List

-   Core functionality <code>[2/3]</code>
    -   [X] Make magit popup
    -   [ ] Checking git lfs status
    -   [X] Connect to git lfs
-   Command specific functionality <code>[6/12]</code>
    -   [ ] checkout
    -   [X] fetch
    -   [X] fsck
    -   [X] install
    -   [ ] logs
    -   [ ] ls-files
    -   [X] pull
    -   [X] push
    -   [ ] status
    -   [ ] track
    -   [ ] untrack
    -   [X] update

