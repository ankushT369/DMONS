// entry-point of the daemon
use std::io::{Read, Write};
use std::net::TcpStream;

fn main() -> std::io::Result<()> {
    let mut stream = TcpStream::connect("127.0.0.1:9121")?;

    // Write raw HTTP GET request
    let request = b"GET /metrics HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n";
    stream.write_all(request)?;

    // Read response
    let mut buffer = String::new();
    stream.read_to_string(&mut buffer)?;
    println!("Raw HTTP Response:\n{}", buffer);

    Ok(())
}

