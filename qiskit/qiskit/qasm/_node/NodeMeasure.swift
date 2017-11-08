// Copyright 2017 IBM RESEARCH. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =============================================================================


import Foundation
/*
 Node for an OPENQASM measure statement.
 children[0] is a primary node (id or indexedid)
 children[1] is a primary node (id or indexedid)
 */
public final class NodeMeasure: Node {

    public let arg1: Node
    public let arg2: Node
    
    @objc public init(arg1: Node, arg2: Node) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
    
    public override var type: NodeType {
        return .N_MEASURE
    }
    
    public override var children: [Node] {
        return [arg1,arg2]
    }
    
    public override func qasm(_ prec: Int) -> String {
        return "measure \(arg1.qasm(prec)) -> \(arg2.qasm(prec));"
    }
}
