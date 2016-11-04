
require('UIAlertController');
require('UIAlertAction');

defineClass('ViewController', {
  showJSPatchMethod: function() {
//    self.showAlret();
    self.showTableVC();
  },

 // 弹出alert
  showAlret: function() {
    var alert = UIAlertController.alertControllerWithTitle_message_preferredStyle('提示', '有新的版本更新,请及时更新，以免影响使用', 1);
    var cancelAction = UIAlertAction.actionWithTitle_style_handler('取消', 1, block('UIAlertAction * _Nonnull',function(action) {
      //
      console.log('取消');
    }));

    var okAction = UIAlertAction.actionWithTitle_style_handler('立即更新', 0, block('UIAlertAction * _Nonnull',function(action) {
      //
      console.log('立即更新');
    }));
    alert.addAction(cancelAction);
    alert.addAction(okAction);

    self.presentViewController_animated_completion(alert, YES, block('', function() {}));
  },

  // 弹出一个tableView页面
  showTableVC: function() {
    var tableVC = JPTableViewController.alloc().init();
    tableVC.navigationItem().setTitle('热修复页面');
    self.navigationController().pushViewController_animated(tableVC, YES);
  }
})


// table页面测试
defineClass('JPTableViewController: UITableViewController <UIAlertViewDelegate>', ['data'], {
  dataSource: function() {
    var data = self.data();
    if (data) {
      return data;
    }
    var temData = [];
    for (var i = 0; i < 20; i++) {
      temData.push('this is ' + i + ' row');
    }
    return temData;
  },

  numberOfSectionsInTableView: function(tableView) {
    return 1;
  },
  tableView_numberOfRowsInSection: function(tableView, section) {
    return self.dataSource().length;
  },
  tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
    var cell = tableView.dequeueReusableCellWithIdentifier("cell");
    if (!cell) {
      cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell");
    }
    cell.textLabel().setText(self.dataSource()[indexPath.row()]);
    return cell;
  },
  tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
    return 40.0;
  },
  tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
     var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource()[indexPath.row()], self, "OK",  null);
     alertView.show();
  },
  alertView_willDismissWithButtonIndex: function(alertView, idx) {
    console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS());
           // self.navigationController().popViewControllerAnimated(YES);
  }
})
