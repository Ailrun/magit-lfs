;;; magit-lfs --- Magit plugin for Git LFS

;; Copyright (C) 2017- Junyoung Clare Jang

;; Author: Junyoung Clare Jang <jjc9310@gmail.com>
;; Maintainer: Junyoung Clare Jang <jjc9310@gmail.com>
;; Created: 25 Feb 2017
;; Version: 0.0.1
;; Package-Requires: (magit)
;; Keywords: magit git lfs tools vc
;; URL: https://github.com/ailrun/package-stack

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

;; The `magit-lfs' is plugin for `magit', most famous Emacs-Git integration.
;; This plugin is `magit' integrated frontend for Git LFS,
;; Git Large File System.
;;
;; To use this plugin,
;;
;; 1. Install git-lfs.
;;
;; 2. Use following codes in your Emacs setting.
;;
;; - For Vanilla Emacs:
;;
;;   (require 'magit-lfs)
;;   (auto-inject-magit-lfs t)
;;
;; - For Emacs with `use-package':
;;
;;   (use-package magit-lfs
;;      :ensure t
;;      :pin melpa
;;      :config
;;      (auto-inject-magit-lfs t))
;;
;; For more detail information, please see README.md

;;; Code:

(require 'magit)

(defgroup magit-lfs nil
  ""
  :group 'magit)

(magit-define-popup magit-lfs/top-popup
  "Popup console for top-level magit-lfs commands."
  'magit-lfs
  :man-page "git-lfs"
  :actions '("Popup and Commands"
             (?C "fsck, Check file" magit-lfs/fsck)
             (?f "fetch, Download file" magit-lfs/fetch-popup)
             (?F "pull, Fetch & checkout files" magit-lfs/pull-popup)
             (?i "install, Install configuration" magit-lfs/install-popup)
             (?l "logs, Show error logs for LFS" magit-lfs/logs-popup)
             (?P "push, Push files to end point" magit-lfs/push-popup)
             (?U "update, Update hook for repo" magit-lfs/update-popup)))

(magit-define-popup-action 'magit-dispatch-popup
  ?& "Magit-LFS" #'magit-lfs/top-popup ?!)
(define-key magit-status-mode-map
  "&" #'magit-lfs/top-popup)

(magit-define-popup magit-lfs/fetch-popup
  ""
  'magit-lfs
  :man-page "git-lfs-fetch"
  :switches '((?p "Prune old/unreferenced after fetch" "-p")
              (?a "Download all objects" "--all")
              (?r "Download recent changes" "--recent"))
  :options '((?I "Include" "--include=")
             (?X "Exclude" "--exclude="))
  :actions '("Fetch from"
             (?u "upstream" magit-lfs/fetch-from-upstream)))

(magit-define-popup magit-lfs/pull-popup
  ""
  'magit-lfs
  :man-page "git-lfs-pull")

(magit-define-popup magit-lfs/install-popup
  ""
  'magit-lfs
  :man-page "git-lfs-install"
  :options '((?F "Set LFS by overwriting values" "--force")
             (?s "Skips automatic downloading for clone/pull" "--skip-smudge"))
  :actions '("Set in"
             (?l "Local repository's config"
                 magit-lfs/install-to-local-config)
             (?g "Global config"
                 magit-lfs/install-to-global-config)))

(magit-define-popup magit-lfs/logs-popup
  ""
  'magit-lfs
  :man-page "git-lfs-logs"
  :actions '("Actions"
             (?b "Triggers a dummy exception" magit-lfs/logs-boomtown)
             (?c "Clear error logs" magit-lfs/logs-clear)
             (?s "Show logs" magit-lfs/logs-show)))

(magit-define-popup magit-lfs/push-popup
  ""
  'magit-lfs
  :man-page "git-lfs-push"
  :switches '((?d "Dry run" "--dry-run")
              (?a "Push all objects to remote" "--all"))
  :actions '("Push to"
             (?u "upstream" magit-lfs/push-to-upstream)))

(magit-define-popup magit-lfs/update-popup
  ""
  'magit-lfs
  :man-page "git-lfs-update"
  :switches '((?f "Update hook, clobbering existing contents" "--force"))
  :actions '(("Actions"
              (?r "update" magit-lfs/update))))


(defun magit-lfs/fsck ()
  "Magit binding for git lfs fsck.")


(defun magit-lfs/fetch-upstream ()
  "Magit binding for git lfs fetch upstream.")


(defun magit-lfs/install-to-local-config ()
  "Magit binding for git lfs install --local.")

(defun magit-lfs/install-to-global-config ()
  "Magit binding for git lfs install.")


(defun magit-lfs/logs-boomtown ()
  "Magit binding for git lfs logs --boomtown.")

(defun magit-lfs/logs-clear ()
  "Magit binding for git lfs logs --clear.")

(defun magit-lfs/logs-show ()
  "Magit binding for git lfs logs --show.")


(defun magit-lfs/ls-files ()
  "Magit binding for git lfs ls-files.")


(defun magit-lfs/pull-upstream ()
  "Magit binding for git lfs pull upstream.")


(defun magit-lfs/push-upstream ()
  "Magit binding for git lfs push upstream.")


(defun magit-lfs/update ()
  "Magit binding for git lfs update.")



(provide 'magit-lfs)

;;; magit-lfs.el ends here
