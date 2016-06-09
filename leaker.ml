open Core.Std
open Async.Std
open Async_ssl.Std

let host = "127.0.0.1"
let port = 4000

let request =
  "GET / HTTP/1.1\r\n\
   Host: localhost\r\n\
   Connection: close\r\n\
   \r\n"

let rec loop () =
  print_char '|';
  Tcp.with_connection (Tcp.to_host_and_port host port) (fun _ r w ->
      let net_to_ssl = Reader.pipe r in
      let ssl_to_net = Writer.pipe w in
      let app_to_ssl, app_wr = Pipe.create () in
      let app_rd, ssl_to_app = Pipe.create () in
      Ssl.client ~app_to_ssl ~ssl_to_app ~net_to_ssl ~ssl_to_net ()
      >>= function
      | Error err -> Error.raise err
      | Ok conn ->
        Pipe.write_without_pushback app_wr request;
        Pipe.close app_wr;
        Pipe.drain_and_count app_rd >>= (fun c ->
            assert (c > 0);
            Pipe.closed app_rd)
    ) >>= fun () ->
  loop ()

let () =
  don't_wait_for (loop ());
  never_returns (Scheduler.go ())

