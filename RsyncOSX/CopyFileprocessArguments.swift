//
//  scpNSTaskArguments.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 27/06/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation


enum enumscopyfiles {
    case rsync
    case du
}

final class CopyFileprocessArguments: ProcessArguments {
    
    // File to read
    private var file:String?
    // Array for storing arguments
    private var arguments:Array<String>?
    // String for display
    private var argDisplay:String?
    // command string
    private var command:String?
    // config, is set in init
    private var config:configuration?
    
    // Getting arguments
    func getArguments() -> Array<String>? {
        return self.arguments
    }
    // Getting command
    func getCommand() -> String? {
        return self.command
    }
    
    // Getting the command to display in view
    func getcommandDisplay() -> String {
        guard self.argDisplay != nil else {
            return ""
        }
        return self.argDisplay!
    }
    
 
    init (task : enumscopyfiles, config : configuration, remoteFile : String?, localCatalog : String?, drynrun:Bool?) {
        
        // Initialize the argument array
        self.arguments = nil
        self.arguments = Array<String>()
        // Set config
        self.config = config
        
        switch (task) {
        case .rsync:
            // Arguments for rsync
            let arguments = rsyncArguments(config: config, remoteFile: remoteFile, localCatalog: localCatalog, drynrun: drynrun)
            self.arguments = arguments.getArguments()
            self.command = arguments.getCommand()
        case .du:
            // Remote du -a
            let arguments = getRemoteFilelist(config: config)
            self.arguments = arguments.getArguments()
            self.command = arguments.getCommand()
        }
    }
}