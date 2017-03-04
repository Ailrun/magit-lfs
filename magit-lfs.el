;;; magit-lfs --- Magit plugin for Git LFS

;; Copyright (C) 2017- Junyoung Clare Jang

;; Author: Junyoung Clare Jang <jjc9310@gmail.com>
;; Maintainer: Junyoung Clare Jang <jjc9310@gmail.com>
;; Created: 25 Feb 2017
;; Version: 0.0.1
;; Package-Requires: (magit)
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
;; - For Vanilla Emacs (After install magit, dash, magit-lfs):
;;
;;   (require 'magit-lfs)
;;   (auto-inject-magit-lfs t)
;;
;; - For Emacs with `use-package' (After load magit, dash):
;;
;;   (use-package magit-lfs
;;      :ensure t
;;      :pin melpa)
;;
;; - For Emacs with `req-package' (After install dash):
;;
;;   (req-package magit-lfs
;;      :loader :elpa
;;      :pin melpa
;;      :require (magit))
;;
;; For more detail information, please see README.md

;;; Code:

(require 'magit)
(require 'magit-lfs-core)

(magit-define-popup magit-lfs/top-popup
  "Popup console for top-level magit-lfs commands."
  'magit-lfs
  :man-page "git-lfs"
  :actions '("Popup and Commands"
             (?f "fetch, Download file"
                 magit-lfs/fetch-popup)
             (?F "pull, Fetch & checkout files"
                 magit-lfs/pull-popup)
             (?i "install, Install configuration"
                 magit-lfs/install-popup)
             ;; (?l "logs, Show error logs for LFS"
             ;;     magit-lfs/logs-popup)
             (?P "push, Push files to end point"
                 magit-lfs/push-popup)
             (?U "update, Update hook for repo"
                 magit-lfs/update-popup)
             (?! "fsck, Check file"
                 magit-lfs/fsck)))

(magit-define-popup-action 'magit-dispatch-popup
  ?& "Magit-LFS" #'magit-lfs/top-popup ?!)
(define-key magit-status-mode-map
  "&" #'magit-lfs/top-popup)

(magit-define-popup magit-lfs/fetch-popup
  ""
  'magit-lfs
  :man-page "git-lfs-fetch"
  :switches '((?p "Prune old/unreferenced after fetch"
                  "--prune")
              (?a "Download all objects"
                  "--all")
              (?r "Download recent changes"
                  "--recent"))
  :options '((?I "Include"
                 "--include=")
             (?X "Exclude"
                 "--exclude="))
  :actions '("Fetch from"
             (?p magit-get-push-remote
                 magit-lfs/fetch-from-pushremote)
             (?u magit-get-remote
                 magit-lfs/fetch-from-upstream)
             (?e "elsewhere"
                 magit-lfs/fetch)
             "Fetch"
             (?o "another branch"
                 magit-lfs/fetch-branch)))

(magit-define-popup magit-lfs/pull-popup
  ""
  'magit-lfs
  :man-page "git-lfs-pull"
  :options '((?I "Include"
                 "--include=")
             (?X "Exclude"
                 "--exclude="))
  :actions '((lambda ()
               (--if-let (magit-get-current-branch)
                   (concat
                    (propertize "Pull into " 'face 'magit-popup-heading)
                    (propertize it 'face 'magit-branch-local)
                    (propertize " from" 'face 'magit-popup-heading))
                 (propertize "Pull from" 'face 'magit-popup-heading)))
             ;; (?p magit-get-push-branch magit-pull-from-pushremote)
             (?u magit-get-upstream-branch
                 magit-lfs/pull-from-upstream)
             (?e "elsewhere"
                 magit-lfs/pull)
             "Fetch"
             (?o "another branch" magit-fetch-branch)))

(magit-define-popup magit-lfs/install-popup
  ""
  'magit-lfs
  :man-page "git-lfs-install"
  :options '((?F "Set LFS by overwriting values"
                 "--force")
             (?s "Skips automatic downloading for clone/pull"
                 "--skip-smudge"))
  :actions '("Set in"
             (?l "Local repository's config"
                 magit-lfs/install-to-local-config)
             (?g "Global config"
                 magit-lfs/install-to-global-config)))

;; (magit-define-popup magit-lfs/logs-popup
;;   ""
;;   'magit-lfs
;;   :man-page "git-lfs-logs"
;;   :actions '("Actions"
;;              (?b "Triggers a dummy exception" magit-lfs/logs-boomtown)
;;              (?c "Clear error logs" magit-lfs/logs-clear)
;;              (?s "Show logs" magit-lfs/logs-show)))

(magit-define-popup magit-lfs/push-popup
  ""
  'magit-lfs
  :man-page "git-lfs-push"
  :switches '((?d "Dry run"
                  "--dry-run")
              (?a "Push all objects to remote"
                  "--all"))
  :actions '((lambda ()
               (--when-let (magit-get-current-branch)
                 (concat (propertize "Push " 'face 'magit-popup-heading)
                         (propertize it      'face 'magit-branch-local)
                         (propertize " to"   'face 'magit-popup-heading))))
             (?p magit--push-current-to-pushremote-desc
                 magit-lfs/push-current-to-pushremote)
             (?u magit--push-current-to-upstream-desc
                 magit-lfs/push-current-to-upstream)
             (?e "elsewhere\n"
                 magit-lfs/push-current)
             "Push"
             (?o "another branch"
                 magit-lfs/push)))

(magit-define-popup magit-lfs/update-popup
  ""
  'magit-lfs
  :man-page "git-lfs-update"
  :switches '((?f "Update hook, clobbering existing contents"
                  "--force"))
  :actions '("Actions"
             (?r "update"
                 magit-lfs/update)))


(defun magit-lfs/fsck ()
  "Magit binding for git lfs fsck."
  (interactive)
  (magit-lfs/with-lfs 'magit-run-git-async "fsck"))


(defun magit-lfs/fetch-command (remote args)
  (run-hooks 'magit-credential-hook)
  (magit-lfs/with-lfs 'magit-run-git-async
    "fetch" remote args))

(defun magit-lfs/fetch-from-pushremote (args)
  "Magit binding for git lfs fetch push-remote of the current branch."
  (interactive
   (list (magit-lfs/fetch-arguments)))
  (--if-let (magit-get-push-remote)
      (magit-lfs/fetch-command it args)
    (--if-let (magit-get-current-branch)
        (user-error "No push-remote is configured for %s" it)
      (user-error "No branch is checked out"))))

(defun magit-lfs/fetch-from-upstream (args)
  "Magit binding for git lfs fetch upstream."
  (interactive
   (list (magit-lfs/fetch-arguments)))
  (--if-let (magit-get-remote)
      (magit-lfs/fetch-command it args)
    (--if-let (magit-get-current-branch)
        (user-error "No upstream is configured for %s" it)
      (user-error "No branch is checked out"))))

(defun magit-lfs/fetch (remote args)
  "Magit binding for git lfs fetch REMOTE."
  (interactive
   (list (magit-read-remote "Fetch remote")
         (magit-lfs/fetch-arguments)))
  (magit-lfs/fetch-command remote args))

(defun magit-fetch-branch (remote branch args)
  "Magit binding for git lfs fetch REMOTE BRANCH."
  (interactive
   (let ((remote (magit-read-remote-or-url "Fetch from remote or url")))
     (list remote
           (magit-read-remote-branch "Fetch branch" remote)
           (magit-lfs/fetch-arguments))))
  (magit-lfs/fetch-command remote (cons branch args)))


(defun magit-lfs/install-command (args)
  (magit-lfs/with-lfs 'magit-run-git-async
    "install" args))

(defun magit-lfs/install-to-local-config (args)
  "Magit binding for git lfs install --local."
  (interactive
   (list (magit-lfs/install-arguments)))
  (magit-lfs/install (cons "--local" args)))

(defun magit-lfs/install-to-global-config (args)
  "Magit binding for git lfs install."
  (interactive
   (list (magit-lfs/install-arguments)))
  (magit-lfs/install args))


;; (defun magit-lfs/logs-boomtown ()
;;   "Magit binding for git lfs logs --boomtown.")

;; (defun magit-lfs/logs-clear ()
;;   "Magit binding for git lfs logs --clear.")

;; (defun magit-lfs/logs-show ()
;;   "Magit binding for git lfs logs --show.")


;; (defun magit-lfs/ls-files ()
;;   "Magit binding for git lfs ls-files.")


(defun magit-lfs/pull-command (source args)
  (run-hooks 'magit-credential-hook)
  (-let [(remote . branch)
         (magit-split-branch-name source)]
    (magit-lfs/with-lfs 'magit-run-git-with-editor
      "pull" args remote branch)))

(defun magit-lfs/pull-from-pushremote (args)
  "Magit binding for git lfs pull push-remote of the current branch."
  (interactive
   (list (magit-lfs/pull-arguments)))
  (--if-let (magit-get-push-branch)
      (magit-lfs/pull-command it args)
    (--if-let (magit-get-current-branch)
        (user-error "No push-remote is configured for %s" it)
      (user-error "No branch is checked out"))))

(defun magit-lfs/pull-from-upstream (args)
  "Magit binding for git lfs pull upstream."
  (interactive
   (list (magit-lfs/pull-arguments)))
  (--if-let (magit-get-upstream-branch)
      (progn (run-hooks 'magit-credential-hook)
             (magit-lfs/with-lfs 'magit-run-git-with-editor
               "pull" args (car (magit-split-branch-name it))))
    (--if-let (magit-get-current-branch)
        (user-error "No upstream is configured for %s" it)
      (user-error "No branch is checked out"))))

(defun magit-pull (source args)
  "Magit binding for git lfs pull."
  (interactive
   (list (magit-read-remote-branch "Pull" nil nil nil t)
         (magit-lfs/pull-arguments)))
  (magit-lfs/pull-command source args))


(defun magit-lfs/push-command (branch target args)
  (run-hooks 'magit-credential-hook)
  (-let [(remote . target)
         (magit-split-branch-name target)]
    (magit-lfs/with-lfs 'magit-run-git-async
      "push" "-v" args remote
      (format "%s:refs/heads/%s" branch target))))

(defun magit-lfs/push-current-to-pushremote (args &optional push-remote)
  "Magit binding for git lfs push push-remote."
  (interactive
   (list (magit-lfs/push-arguments)
         (and (magit--push-current-set-pushremote-p current-prefix-arg)
              (magit-read-remote
               (if (eq magit-push-current-set-remote-if-missing 'default)
                   "Set `remote.pushDefault' and push there"
                 (format "Set `branch.%s.pushRemote' and push there"
                         (magit-get-current-branch)))))))
  (--if-let (magit-get-current-branch)
      (progn (when push-remote
               (setf (magit-get
                      (if (eq magit-push-current-set-remote-if-missing 'default)
                          "remote.pushDefault"
                        (format "branch.%s.pushRemote"
                                (magit-get-current-branch))))
                     push-remote))
             (-if-let (remote (magit-get-push-remote it))
                 (if (member remote (magit-list-remotes))
                     (magit-lfs/push-command it (concat remote "/" it) args)
                   (user-error "Remote `%s' doesn't exist" remote))
               (user-error "No push-remote is configured for %s" it)))
    (user-error "No branch is checked out")))

(defun magit-push-current-to-upstream (args &optional upstream)
  "Magit binding for git lfs push upstream."
  (interactive
   (list (magit-lfs/push-arguments)
         (and (magit--push-current-set-upstream-p current-prefix-arg)
              (magit-read-upstream-branch))))
  (--if-let (magit-get-current-branch)
      (progn
        (when upstream
          (magit-set-branch*merge/remote it upstream))
        (-if-let (target (magit-get-upstream-branch it))
            (magit-lfs/push-command it target args)
          (user-error "No upstream is configured for %s" it)))
    (user-error "No branch is checked out")))


(defun magit-lfs/update (args)
  "Magit binding for git lfs update."
  (interactive
   (list (magit-lfs/fetch-arguments)))
  (magit-lfs/with-lfs 'magit-run-git-async
    "update" args))



(provide 'magit-lfs)

;;; magit-lfs.el ends here
