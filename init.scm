(require (prefix-in helix.static. "helix/static.scm"))
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.editor. "helix/editor.scm"))
(require (prefix-in helix.misc. "helix/misc.scm"))
(require-builtin "steel/process" as process.)

(helix.theme "catppuccin_macchiato")
(helix.set-option "line-number" "relative")

(define wakatime-version "0.1.0")
(define wakatime-agent "helix-wakatime")
(define wakatime-time-key "")
(define wakatime-exe "C:\\Users\\Brian\\.wakatime\\wakatime-cli.exe")

(define (wakatime-get-current-file)
         (Document-path (helix.editor.editor->get-document 
           (helix.editor.editor->doc-id 
             (helix.editor.editor-focus)))))
    
(define (wakatime-write cx)
  (let* ((doc (wakatime-get-current-file))
         (cmd (process.command wakatime-exe (list 
                "--entity" doc
                "--plugin" 
                  (string-append wakatime-agent "/" wakatime-version)
               "--write"
                ))))
    
    (if doc (process.spawn-process cmd) ) ))

(define (wakatime-listen-inserts )
  (register-hook! "post-insert-char" "wakatime-write"))
(wakatime-listen-inserts)

(define (wakatime-heart-beat)
  (let ((doc (wakatime-get-current-file)))

    (if doc (process.spawn-process (process.command wakatime-exe (list 
                "--entity" doc
                "--plugin" 
                (string-append wakatime-agent "/" wakatime-version))))
        #f))
  (run-wakatime))

(define (run-wakatime)
  (helix.misc.enqueue-thread-local-callback-with-delay 1000 wakatime-heart-beat ))

(run-wakatime)
