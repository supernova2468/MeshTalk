import 'dart:io';
import 'dart:math';

main() async {
  var randomGen = Random();
  var futures = <Future>[];
  for (var i = 0; i < 5; i++) {
    futures.add(send(randomGen));
  }
  await Future.wait(futures);
  print('returned from async');
}

Future<void> send(Random random) async {
  print('starting connection');
  var socket = await Socket.connect('0.0.0.0', 12345);
  print('got connection');
  await Future.delayed(Duration(seconds: random.nextInt(10)));
  print('sending data');
  socket.write('test');
  print('finished sending data, closing');
  socket.close();
  print('done');
}
