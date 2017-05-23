//
//  CopyFiles.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 12/09/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation

final class CopyFiles {
    
    // Index from View
    private var index:Int?
    // Setting the configuration element according to index
    private var config:configuration?
    // when files.txt is copied from remote server get the records
    private var files:Array<String>?
    // Arguments and command for Process object
    private var arguments:Array<String>?
    private var command:String?
    // The arguments object
    var argumentsObject:CopyFileprocessArguments?
    // Message to calling class do a refresh
    weak var refreshtable_delegate:RefreshtableView?
    // Command real run - for the copy process (by rsync)
    private var argumentsRsync:Array<String>?
    // Command dry-run - for the copy process (by rsync)
    private var argymentsRsyncDrynRun:Array<String>?
    // String to display in view
    private var commandDisplay:String?
    // Start and stop progress view
    weak var progress_delegate: StartStopProgressIndicator?
    // The Process object
    var process:commandCopyFiles?
    // rsync outPut object
    var output:outputProcess?
    
    
    // Get output from Rsync
    func getOutput() -> Array<String> {
        return self.output!.getOutput()
    }
    
    // Abort operation, terminate process
    func Abort() {
        guard self.process != nil else {
            return
        }
        self.process!.abortProcess()
    }
    
    // Execute Process (either dryrun or realrun)
    func executeRsync(remotefile:String, localCatalog:String, dryrun:Bool) {
        
        guard self.config != nil else {
            return
        }
        
        if(dryrun) {
            self.argumentsObject = CopyFileprocessArguments(task: .rsync, config: self.config!, remoteFile: remotefile, localCatalog: localCatalog, drynrun: true)
            self.arguments = self.argumentsObject!.getArguments()
        } else {
            self.argumentsObject = CopyFileprocessArguments(task: .rsync, config: self.config!, remoteFile: remotefile, localCatalog: localCatalog, drynrun: nil)
            self.arguments = self.argumentsObject!.getArguments()
        }
        self.command = nil
        self.output = nil
        self.process = commandCopyFiles(command : nil, arguments: self.arguments)
        self.output = outputProcess()
        self.process!.executeProcess(output: self.output!)
    }
    
    // Get arguments for rsync to show
    func getCommandDisplayinView(remotefile:String, localCatalog:String) -> String {
        
        guard self.config != nil else {
            return ""
        }
        
        self.commandDisplay = CopyFileprocessArguments(task: .rsync, config: self.config!, remoteFile: remotefile, localCatalog: localCatalog, drynrun: true).getcommandDisplay()
        guard self.commandDisplay != nil else {
            return ""
        }
        return self.commandDisplay!
    }
    
    private func getRemoteFileList() {
        self.output = nil
        self.argumentsObject = CopyFileprocessArguments(task: .du, config: self.config!, remoteFile: nil, localCatalog: nil, drynrun: nil)
        self.arguments = self.argumentsObject!.getArguments()
        self.command = self.argumentsObject!.getCommand()
        self.process = commandCopyFiles(command : self.command, arguments: self.arguments)
        self.output = outputProcess()
        self.process!.executeProcess(output: self.output!)
    }
    
    func setRemoteFileList(){
        self.files = self.output!.getOutput()
    }
    
    // Filter function
    func filter(search:String?) -> Array<String> {
        
        guard search != nil else {
            if (self.files != nil) {
                return self.files!
            } else {
              return [""]
            }
            
        }
        
        if (search!.isEmpty == false) {
            // Filter data
            return self.files!.filter({$0.contains(search!)})
        } else {
            return self.files!
        }
    }
    
    
    init (index:Int) {
        // Setting index and configuration object
        self.index = index
        self.config = SharingManagerConfiguration.sharedInstance.getConfigurations()[self.index!]
        self.getRemoteFileList()
    }
    
  }
