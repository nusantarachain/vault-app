import 'package:app/service/index.dart';
import 'package:app/store/types/transferData.dart';
import 'package:app/utils/i18n/index.dart';
import 'package:app/utils/safegetter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/txDetail.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';

class TransferDetailPage extends StatelessWidget {
  TransferDetailPage(this.service);

  static final String route = '/assets/tx';
  final AppService service;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic =
        I18n.of(context).getDic(i18n_full_dic_app, 'assets');

      final symbol = SafeGetter.getStr(service.plugin.networkState.tokenSymbol);
      // final decimals = SafeGetter.getInt(service.plugin.networkState.tokenDecimals, 12);


    final TransferData tx = ModalRoute.of(context).settings.arguments;

    final String txType = tx.from == service.keyring.current.address
        ? dic['transfer']
        : dic['receive'];

    String networkName = service.plugin.basic.name;
    if (service.plugin.basic.isTestNet) {
      networkName = '${networkName.split('-')[0]}-testnet';
    }
    return TxDetail(
      success: tx.success,
      action: txType,
      eventId: tx.extrinsicIndex,
      hash: tx.hash,
      blockTime: Fmt.dateTime(
          DateTime.fromMillisecondsSinceEpoch(tx.blockTimestamp)),
      blockNum: tx.blockNum,
      networkName: networkName,
      infoItems: <TxDetailInfoItem>[
        TxDetailInfoItem(
          label: dic['value'],
          // title: '${tx.amount} $symbol',
          title: '${Fmt.priceFloorBigInt(Fmt.balanceInt(tx.amount), 10, lengthMax: 4)} $symbol'
        ),
        // @TODO: enable this when AraScan support fee data in transfers endpoint
        // TxDetailInfoItem(
        //   label: dic['fee'],
        //   title: '${Fmt.balance(tx.fee, decimals, length: decimals)} $symbol',
        // ),
        TxDetailInfoItem(
          label: dic['from'],
          title: Fmt.address(tx.from),
          copyText: tx.from,
        ),
        TxDetailInfoItem(
          label: dic['to'],
          title: Fmt.address(tx.to),
          copyText: tx.to,
        )
      ],
    );
  }
}
