import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      (_selectedDate as DateTime),
    );

    Navigator.of(context).pop(); //Đóng Bottom Modal Sheet
  }

  //Show DatePicker
  void _presentDatePicker() {
    //hàm của Flutter : hiển thị ra cái DatePicker để chọn ngày
    showDatePicker(
      context: context, //context của Widget
      initialDate: DateTime.now(), //ngày khởi điểm: tự động chọn lúc đầu
      firstDate: DateTime(2019), //ngày đầu tiên
      lastDate: DateTime.now(), //ngày cuối cùng
    ).then((pickedDate) {
      //function này nhận vào ngày người dùng chọn
      if (pickedDate == null) {
        //nếu ngày này = null thì nghĩa là người dùng ko chọn gì (nhấn cancel)
        //thì ko làm gì cả
        return;
      }

      //cho vào setSate() vì nó sẽ thay đổi UI -> phải rebuild
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Tên giao dịch',
              ),
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Giá tiền',
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Chưa chọn ngày!'
                          : 'Ngày đã chọn: ${DateFormat.yMd().format((_selectedDate as DateTime))}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Chọn ngày',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  ),
                ],
              ),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('Thêm giao dịch'),
              //textColor: Theme.of(context).textTheme.button.color,  //Lỗi
              textColor: Colors.white,
              onPressed: _submitData,
            )
          ],
        ),
      ),
    );
  }
}
