# Soundcloud Demo

##Setuping project to run

You should follow few steps to make it work

```
	git clone git@github.com:SlavkoKrucaj/SoundCloudDemo.git
	cd SoundCloudDemo
	git submodule update --init --recursive
	open SoundcloudDemo.xcodeproj/
	
```

If you copy paste those few lines you should be able to run the project.

##Code organization

* Main controller which holds the UI is SoundCloudViewController.m
* I have used CoreData for storing activity items. Main model is SoundCloudItem.m.
* Custom cell is called SoundCloudCell.m
* There are a lot of helper classes, so feel free to browse, code should be organized in a way that is easy to read.

##Contact
For any additional info you can contact me on slavko.krucaj@gmail.com