class Tray
{
	InitIcon()
	{
		Menu, Tray, Icon, shell32.dll, 160 ; other options: 16, 253, 255, 306
		Menu, Tray, NoStandard
	}

	__New(settings, build, updateChecker)
	{
		this.settings := settings
		this.build := build
		this.updateChecker := updateChecker

		this.InitIcon()

		aboutMethod := ObjBindMethod(this, "Tray_About")
		Menu, Tray, Add, % this.settings.programTitle, % aboutMethod
		Menu, Tray, Icon, % this.settings.programTitle, shell32.dll, 160

		Menu, Tray, Add, &About, % aboutMethod
		Menu, Tray, Icon, &About, shell32.dll, 222 ; other options: 155, 176, 211, 222, 225, 278

		updateMethod := ObjBindMethod(this, "Tray_Update")
		Menu, Tray, Add, Chec&k for update, % updateMethod
		Menu, Tray, Icon, Chec&k for update, shell32.dll, 47 ; other options: 47, 123

		Menu, Tray, Add

		settingsMethod := ObjBindMethod(this, "Tray_Settings")
		Menu, Tray, Add, &Settings, % settingsMethod
		Menu, Tray, Icon, &Settings, shell32.dll, 316

		reloadMethod := ObjBindMethod(this, "Tray_Reload")
		Menu, Tray, Add, &Reload, % reloadMethod
		Menu, Tray, Icon, &Reload, shell32.dll, 239

		suspendMethod := ObjBindMethod(this, "Tray_Suspend")
		Menu, Tray, Add, S&uspend, % suspendMethod
		Menu, Tray, Icon, S&uspend, shell32.dll, 145 ; other options: 238, 220

		exitMethod := ObjBindMethod(this, "Tray_Exit")
		Menu, Tray, Add, E&xit, % exitMethod
		Menu, Tray, Icon, E&xit, shell32.dll, 132
		
		Menu, Tray, Default, % this.settings.programTitle
		Menu, Tray, Tip, % this.settings.programTitle
	}

	Tray_Noop(itemName, itemPos, menuName)
	{
	}

	Tray_About(itemName, itemPos, menuName)
	{
		Gui, About:New, -MaximizeBox
		
		Gui, About:Font, s24 bold
		Gui, About:Add, Text, , % this.settings.programTitle
		
		Gui, About:Margin, , 0
		Gui, About:Font
		Gui, About:Add, Text, , % (this.build.version ? "v" this.build.version : "AutoHotkey script")
										. ", " (A_PtrSize * 8) "-bit"
										. (this.settings.debug ? ", Debug enabled" : "")
										. (A_IsCompiled ? "" : ", not compiled")
										. (A_IsAdmin ? "" : ", not running as administrator") ; shouldn't ever display
		
		Gui, About:Add, Text, , Copyright (c) Ben Allred
		
		Gui, About:Margin, , 10
		Gui, About:Font, s12
		Gui, About:Add, Text, , % this.settings.programDescription
		Gui, About:Add, Link, , Website: <a href="https://github.com/benallred/SnapX">https://github.com/benallred/SnapX</a>
		
		Gui, About:Margin, , 18
		Gui, About:Show, , % this.settings.programTitle
	}

	Tray_Update(itemName, itemPos, menuName)
	{
		updateFound := this.updateChecker.checkForUpdates()
		
		if (!updateFound)
		{
			MsgBox, 0x40, % this.settings.programTitle " Up To Date", % "You are running the latest version of " this.settings.programTitle "." ; 0x40 = Info
		}
	}

	Tray_Settings(itemName, itemPos, menuName)
	{
		Run, % "notepad.exe " this.settings.iniFile
	}

	Tray_Reload(itemName, itemPos, menuName)
	{
		Reload
	}

	Tray_Suspend(itemName, itemPos, menuName)
	{
		if (A_IsSuspended)
		{
			Menu, Tray, Rename, Res&ume, S&uspend
			Menu, Tray, Icon, S&uspend, shell32.dll, 145
		}
		else
		{
			Menu, Tray, Rename, S&uspend, Res&ume
			Menu, Tray, Icon, Res&ume, shell32.dll, 302
		}
		
		Suspend, Toggle
	}

	Tray_Exit(itemName, itemPos, menuName)
	{
		ExitApp
	}
}

AboutGuiEscape(hwnd)
{
	Gui, About:Destroy
}