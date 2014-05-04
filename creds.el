;;; creds.el --- a simple parser credential file lib

;; Copyright (C) 2013
;;   Antoine R. Dumont <eniotna.t AT gmail.com>

;; Author: Antoine R. Dumont <eniotna.t@gmail.com>
;; Maintainer: Antoine R. Dumont <eniotna.t AT gmail.com>
;; Version: 0.0.4
;; Package-Requires: ()
;; Keywords: credentials
;; URL: https://github.com/ardumont/emacs-creds

;; This file is not part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

;; A small library (non optimal) to deal with more entries than just credentials
;; (The search is linear so not optimal)

;; Here is an example of .authinfo
;; machine machine0 port http login nouser password nopass
;; machine machine1 login some-login password some-pwd port 993
;; machine machine2 login some-login port 587 password some-pwd
;; machine jabber         login some-login password some-pwd
;; machine description    name "my name is" blog some-blog mail some-mail

(defun creds/read-lines (filepath)
  "Return a list of lines from a file."
  (with-temp-buffer
    (insert-file-contents filepath)
    (mapcar (lambda (l) (split-string l "[ ]+")) (split-string (buffer-string) "\n" t))))

(defun creds/get (data entry-name)
  "Return the data list for the line entry-name"
  (when data
    (let* ((d     (carfirst data))
           (entry (second d)))
      (if (equal entry entry-name)
          d
        (creds/get (rest data) entry-name)))))

(defun creds/get-entry (data entry)
  "Given a data list, return the entry in that list"
  (when data
    (let* ((k (first data))
           (v (second data)))
      (if (equal k entry)
          v
        (creds/get-entry (cddr data) entry)))))

(provide 'creds)

;;; creds.el ends here
