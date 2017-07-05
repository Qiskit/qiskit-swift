//
//  IdList.swift
//  qiskit
//
//  Created by Joe Ligman on 6/4/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

/*
 Node for an OPENQASM idlist.
 children is a list of id nodes.
 */
@objc public final class NodeIdList: Node {
    
    public private(set) var identifiers: [Node]?

    public init(identifier: Node?) {
        super.init()
        if let ident = identifier {
            self.identifiers = [ident]
        }
    }
    
    public func addIdentifier(identifier: Node) {
        identifiers?.append(identifier)
    }
    
    public override var type: NodeType {
        return .N_IDLIST
    }
    
    public override var children: [Node] {
        return (identifiers != nil) ? identifiers! : []
    }
    
    public override func qasm() -> String {
        var qasms: [String] = []
        if let list = identifiers {
            qasms = list.flatMap({ (node: Node) -> String in
                return node.qasm()
            })
        }
        return qasms.joined(separator: ",")
    }
}

