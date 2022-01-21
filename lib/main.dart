import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:juno_direct_checkout/juno_direct_checkout.dart';

import 'componets/input_text_widget.dart';

void main() {
  runApp(PaymentWithJuno());
}

class PaymentWithJuno extends StatefulWidget {
  const PaymentWithJuno() : super();

  @override
  _PaymentWithJunoState createState() => _PaymentWithJunoState();
}

class _PaymentWithJunoState extends State<PaymentWithJuno> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Cartão de crédito",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Color.fromRGBO(61, 61, 61, 1),
                  Color.fromRGBO(25, 25, 25, 1)
                ],
              ),
            ),
          ),
        ),
        body: new CustomScroll(),
      ),
    );
  }
}

class CustomScroll extends StatefulWidget {
  const CustomScroll();

  @override
  State createState() => new CustomScrollState();
}

class CustomScrollState extends State<CustomScroll> {
  final TextEditingController _cardNumber =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _validity = MaskedTextController(mask: '00/0000');
  final TextEditingController _cardCvv = MaskedTextController(mask: '000');
  final TextEditingController _cardHolderName = TextEditingController();
  bool cardShowBackView = false;
  static const double kEffectHeight = 65;
  bool asc = true;
  bool finished = true;
  double offset = 0.0;
  bool progress = true;

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = new ScrollController();
    scrollController.addListener(updateOffset);
  }

  @override
  void dispose() {
    scrollController.removeListener(updateOffset);
    super.dispose();
  }

  void updateOffset() {
    setState(() {
      offset = scrollController.offset;
    });
  }

  Future sendCardInfo() async {
    try {
      var map = <String, dynamic>{
        "prod": false,
        "public_token":
            "2C17DA59A59D733A89FE750AA33E14BAB83BE370AB818D1BC3117E4899576832"
      };
      print(await JunoDirectCheckout.init(map));
      var card = <String, dynamic>{
        "prod": false,
        "public_token":
            "2C17DA59A59D733A89FE750AA33E14BAB83BE370AB818D1BC3117E4899576832",
        "cardNumber": this._cardNumber.text,
        "holderName": this._cardHolderName.text,
        "securityCode": this._cardCvv.text,
        "expirationMonth": this._validity.text.split("/")[0],
        "expirationYear": this._validity.text.split("/")[1]
      };
      String hash = await JunoDirectCheckout.getCardHash(card);
      var dio = Dio();
      final snackBar = SnackBar(
        content: const Text('Aguarde um momento...'),
        action: SnackBarAction(
          label: 'fechar',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      final snackBar2 = SnackBar(
        content: const Text('Pagamento concluido'),
        action: SnackBarAction(
          label: 'fechar',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Response response = await dio
          .post('https://api-marco-videos.herokuapp.com/v1/payments', data: {
        "references": "id de pagamento 1",
        "amount": 20.00,
        "user": {
          "name": "Nina Camila Porto",
          "cpf": "108.112.559-48",
          "email": "marcolimasistemas@gmail.com",
          "address_street": "Rua Ana Neri",
          "address_number": "8",
          "address_complement": "NA",
          "address_neighborhood": "Boa Vista",
          "address_city": "Mossoró",
          "address_state": "RN",
          "address_zip_code": "59605060",
          "cell_phone": "84989316734",
          "date_of_birth": "1957-01-02"
        },
        "creditCardHash": hash
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      print(response.data);
    } catch (error) {
      final snackBar3 = SnackBar(
        content: const Text('Error ao enviar dados ao servidor de pagamento'),
        action: SnackBarAction(
          label: 'fechar',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          new Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: <Color>[
                    Color.fromRGBO(61, 61, 61, 1),
                    Color.fromRGBO(25, 25, 25, 1)
                  ]),
            ),
            height: (kEffectHeight - offset * 0.5).clamp(0.0, kEffectHeight),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              controller: scrollController,
              children: <Widget>[
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CreditCardWidget(
                    cardNumber: this._cardNumber.text,
                    expiryDate: this._validity.text,
                    cardHolderName: this._cardHolderName.text,
                    cvvCode: this._cardCvv.text,
                    showBackView: this.cardShowBackView,
                    cardBgColor: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 5, top: 30),
                  child: Text(
                    'Número do cartão:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                InputTextWidget(
                  label: '4111654656495467',
                  controller: this._cardNumber,
                  onTap: () {
                    if (cardShowBackView)
                      setState(() {
                        this.cardShowBackView = false;
                      });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Validade:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.35,
                          child: InputTextWidget(
                            label: '10/2030',
                            controller: this._validity,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'CVV:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.35,
                          child: InputTextWidget(
                            label: '123',
                            controller: this._cardCvv,
                            onTap: () {
                              if (!cardShowBackView)
                                setState(
                                  () {
                                    this.cardShowBackView = true;
                                  },
                                );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 5, top: 5),
                  child: Text(
                    'Nome do titular:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                InputTextWidget(
                  label: 'Nome como aparece em seu cartão',
                  controller: this._cardHolderName,
                  onTap: () {
                    if (cardShowBackView)
                      setState(() {
                        this.cardShowBackView = false;
                      });
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  child: IconButton(
                    icon: Icon(Icons.payment),
                    onPressed: sendCardInfo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
