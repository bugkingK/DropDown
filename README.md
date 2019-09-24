## BKDropDown
An API for DropDown with streams similar Rx

## Installation
<b>CocoaPods:</b>
<pre>
pod 'BKDropDown'
</pre>
<b>Manual:</b>
<pre>
Copy <i>BKDropDown.swift, BKDropDown.storyboard</i> to your project.
</pre>

## Using

```swift
let dropDown = BKDropDown.instance()
    .bind(["Item 1", "Item 2", "Item 3", "Item 4"])
    .setLayoutCell(normal: .white, highlight: .lightGray,height: 50)
    .setLayoutTitle(normal: .darkGray, highlight: .darkGray ,font: UIFont.systemFont(ofSize: 14))
    .setPadding(leading: 20, trailing: 20)
    .setDidSelectRowAt({ (idx, item, dropDown) in
        dropDown.hide()
    })
    .show(self, targetView: sender)
```

## License

<i>BKDropDown</i> is available under the MIT license. See the LICENSE file for more info.
