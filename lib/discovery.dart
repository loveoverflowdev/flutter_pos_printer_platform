import 'dart:io';

import 'flutter_pos_printer_platform.dart';
import 'flutter_star_prnt/flutter_star_prnt.dart';

class PrinterDiscovered<T> {
  String name;
  T detail;
  PrinterDiscovered({
    required this.name,
    required this.detail,
  });
}

typedef DiscoverResult<T> = List<PrinterDiscovered<T>>;
typedef StarPrinterInfo = PortInfo;

Future<DiscoverResult<StarPrinterInfo>> discoverStarPrinter() async {
  if (Platform.isAndroid || Platform.isIOS) {
    return (await StarPrnt.portDiscovery(StarPortType.All))
        .map((e) => PrinterDiscovered<StarPrinterInfo>(
              name: e?.modelName ?? 'Star Printer',
              detail: e,
            ))
        .toList();
  }
  return [];
}

Future<List<PrinterDiscovered>> discoverPrinters(
    {List<Function> modes = const [
      discoverStarPrinter,
      UsbPrinterConnector.discoverPrinters,
      BluetoothPrinterConnector.discoverPrinters,
      TcpPrinterConnector.discoverPrinters
    ]}) async {
  List<PrinterDiscovered> result = [];
  await Future.wait(modes.map((m) async {
    result.addAll(await m());
  }));
  return result;
}
