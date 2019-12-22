class TcpListener {
  TcpListener() {
    startListening();
  }

  startListening() async {
    await Future.delayed(Duration(seconds: 3), () => print('Listening'));
    startListening();
  }
}
