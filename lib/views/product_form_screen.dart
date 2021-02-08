import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

//stateful pq tem formulários ne?
class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode(); //pra mudar o foco pro preço
  final _descriptionFocusNode = FocusNode(); //pra mudar o foco pra descrição
  final _imageUrlFocusNode = FocusNode(); //pra mudar o foco pra imagem url
  final _imageUrlController =
      TextEditingController(); //controller para ter acesso ao que é editado
  final _form = GlobalKey<
      FormState>(); //normalmente utiliza key qnd precisa interagir com um widget dentro do codigo
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    // a partir da inicialização do estado, adicionar um listener no url
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  //metodo que está associado ao state
  //sempre que vai renderizar novamente a arvore e o widget muda,
  //o state permanece e o widget é mudado
  void didChangeDependencies() {
    super.didChangeDependencies();
    //se o formData estiver vazio, ai sim vai inicializar o formData
    //com os dados obtidos a partir da rota
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      //se o produto nao for nulo
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    //set state pra atualizar o componente sempre que sair do foco
    if ((!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https')) ||
        (!_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg'))) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    // dispose é utilizado para liberar espaço de memória de objetos que foram removidos
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    //função para salvar os dados que foram passados do novo produto
    //pega o valor digitado e armazena-o
    final isValid =
        _form.currentState.validate(); //chama o validate de cada textform
    if (!isValid) {
      //se o valor não for valido
      return; //so sai da função e nao salva
    }
    _form.currentState.save(); //chama o OnSaved de cada produto
    //adiciona o produto a lista de produtos através do provider

    //pega os dados passados e coloca no formData, criando um produto
    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );

    //pra dizer que está processando
    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);
    //se o formdata for nulo, chama o add produtos
    try {
      if (_formData['id'] == null) {
        await products.addProduct(product); //espera pra add produto
      } else {
        await products.updateProduct(product); //espera atualizar o produto
      }
    } catch (error) {
      //se tiver erro
      await showDialog<Null>(
        //espera pra mostrar o dialogo
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro ao salvar o produto!'),
          actions: [
            FlatButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    } finally {
      //o que vai ser executado indepente do sucesso ou da falha
      setState(() {
        _isLoading = false; //nao está mais carregando
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body: _isLoading //se estiver carregando mostra o spinner
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                //recebe apenas um único formulário
                key: _form, //widget que o key interage
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction
                          .next, //vai para o proximo form, nao acontece de forma automática
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            _priceFocusNode); //qnd clicar em next o foco muda pro preço
                      },
                      onSaved: (value) => _formData['title'] = value,
                      validator: (value) {
                        //se o titulo estiver vazio. trim para tirar os espaços em branco
                        bool isEmpty = value.trim().isEmpty;
                        if (isEmpty) {
                          return 'Informe um Título válido!';
                        }
                        return null; //senão, retorna null
                      }, //pra validar os dados
                    ),
                    TextFormField(
                        initialValue: _formData['price'].toString(),
                        decoration: InputDecoration(labelText: 'Preço'),
                        textInputAction: TextInputAction
                            .next, //vai para o proximo form, nao acontece de forma automática
                        focusNode: _priceFocusNode, //foco do preço
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(
                              _descriptionFocusNode); //qnd clicar em next o foco muda pro description
                        },
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true), //exibe o teclado numérico
                        onSaved: (value) =>
                            _formData['price'] = double.parse(value),
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;
                          var newPrice = double.tryParse(value);
                          bool isInvalid = newPrice == null || newPrice <= 0;

                          if (isEmpty || isInvalid) {
                            return 'Informe um Preço válido!';
                          }

                          return null;
                        }),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3, //texto de até 3 linhas
                      keyboardType:
                          TextInputType.multiline, //teclado para multilinhas
                      textInputAction: TextInputAction
                          .next, //vai para o proximo form, nao acontece de forma automática
                      focusNode: _descriptionFocusNode, //foco da descrição
                      onSaved: (value) => _formData['description'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        if (isEmpty) {
                          return 'Informe uma Descrição válida!';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'URL da Imagem'),
                            keyboardType: TextInputType.url, //teclado de url
                            textInputAction: TextInputAction.done, //done
                            focusNode: _imageUrlFocusNode,
                            controller:
                                _imageUrlController, //controller pra ter acesso às informações
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) => _formData['imageUrl'] = value,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Informe a URL da imagem!';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Informe uma URL válida!';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Informe uma URL válida!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController
                                  .text.isEmpty //se a url estiver vazia
                              ? Text('Informe a URL') //exibe esse texto
                              : Image.network(
                                  //caso contrario, exibe a imagem
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
