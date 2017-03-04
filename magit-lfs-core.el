;;; magit-lfs-core.el --- Core functions/macros for magit-lfs

;; Copyright (C) 2017- Junyoung Clare Jang

;; Author: Junyoung Clare Jang <jjc9310@gmail.com>
;; Maintainer: Junyoung Clare Jang <jjc9310@gmail.com>
;; Created: 25 Feb 2017
;; Version: 0.3.1
;; Package-Requires: ((emacs "24.3") (magit "20170128.745"))
;; Keywords: magit git lfs tools vc
;; URL: https://github.com/ailrun/magit-lfs

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with package-stack; see the file COPYING.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'magit)

(defgroup magit-lfs nil
  ""
  :group 'magit)

(defcustom magit-lfs-git-lfs-executable "git-lfs"
  "Git LFS executable for magit-lfs."
  :group 'magit-lfs
  :version "0.0.1"
  :type 'string)

(defcustom magit-lfs-git-lfs-command "lfs"
  "Git LFS command for magit-lfs."
  :group 'magit-lfs
  :version "0.0.1"
  :type 'string)

(defun magit-lfs-with-lfs (magit-function command &rest args)
  "Internal function for magit-lfs."
  (declare (indent 1))
  (if (null (executable-find magit-lfs-git-lfs-executable))
      (user-error "Git LFS executable %s is not installed; aborting"
             magit-lfs-git-lfs-executable)
    (apply magit-function magit-lfs-git-lfs-command command args)))

(provide 'magit-lfs-core)

;;; magit-lfs-core.el ends here
