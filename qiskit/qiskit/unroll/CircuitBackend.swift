//
//  CircuitBackend.swift
//  qiskit
//
//  Created by Manoel Marques on 6/6/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

/**
 Backend for the unroller that creates a Circuit object
*/
final class CircuitBackend: UnrollerBackend {

    private let prec: Int = 15
    private var creg:RegBit? = nil
    private var cval:Int? = nil
    let circuit: Circuit = Circuit()
    private var basis: [String]
    private var listen: Bool = true
    private var in_gate: String = ""
    private var gates: [String:GateData] = [:]

    /**
     Setup this backend.
     basis is a list of operation name strings.
     */
    init(_ basis: [String] = []) {
        self.basis = basis
    }

    /**
     Declare the set of user-defined gates to emit.
     basis is a list of operation name strings.
     */
    func set_basis(_ basis: [String]) {
        self.basis = basis
    }

    /**
     Print the version string.
     v is a version number.
     */
    func version(_ version: String) {
    }

    /**
     Create a new quantum register.
     name = name of the register
     sz = size of the register
     */
    func new_qreg(_ name: String, _ size: Int) throws {
        try self.circuit.add_qreg(name, size)
    }

    /**
     Create a new classical register.
     name = name of the register
     sz = size of the register
     */
    func new_creg(_ name: String, _ size: Int) throws {
        try self.circuit.add_creg(name, size)
    }

    /**
     Define a new quantum gate.
     name is a string.
     gatedata is the AST node for the gate.
     */
    func define_gate(_ name: String, _ gatedata: GateData) throws {
        self.gates[name] = gatedata
        try self.circuit.add_gate_data(name, gatedata)
    }

    /**
     Fundamental single qubit gate.
     arg is 3-tuple of float parameters.
     qubit is (regname,idx) tuple.
     */
    func u(_ arg: (Double, Double, Double), _ qubit: RegBit) throws {
        if self.listen {
            var condition: RegBit? = nil
            if let reg = self.creg {
                condition = reg
            }
            if !self.basis.contains("U") {
                self.basis.append("U")
                try self.circuit.add_basis_element("U", 1, 0, 3)
            }
            try self.circuit.apply_operation_back("U", [qubit], [], [String(arg.0),String(arg.1),String(arg.2)], condition)
        }
    }

    /**
     Fundamental two qubit gate.
     qubit0 is (regname,idx) tuple for the control qubit.
     qubit1 is (regname,idx) tuple for the target qubit.
     */
    func cx(_ qubit0: RegBit, _ qubit1: RegBit) throws {
        if self.listen {
            var condition: RegBit? = nil
            if let reg = self.creg {
                condition = reg
            }
            if !self.basis.contains("CX") {
                self.basis.append("CX")
                try self.circuit.add_basis_element("CX", 2)
            }
            try self.circuit.apply_operation_back("CX", [qubit0, qubit1], [], [], condition)
        }
    }

    /**
     Measurement operation.
     qubit is (regname, idx) tuple for the input qubit.
     bit is (regname, idx) tuple for the output bit.
     */
    func measure(_ qubit: RegBit, _ bit: RegBit) throws {
        var condition: RegBit? = nil
        if let reg = self.creg {
            condition = reg
        }
        if !self.basis.contains("measure") {
            self.basis.append("measure")
            try self.circuit.add_basis_element("measure", 1, 1)
        }
        try self.circuit.apply_operation_back("measure", [qubit], [bit], [], condition)
    }

    /**
     Barrier instruction.
     qubitlists is a list of lists of (regname, idx) tuples.
     */
    func barrier(_ qubitlists: [[RegBit]]) throws {
        if self.listen {
            var names: [RegBit] = []
            for x in qubitlists {
                for reg in x {
                    names.append(reg)
                }
            }
            if !self.basis.contains("barrier") {
                self.basis.append("barrier")
                try self.circuit.add_basis_element("barrier", -1)
            }
            try self.circuit.apply_operation_back("barrier", names)
        }
    }

    /**
     Reset instruction.
     qubit is a (regname, idx) tuple.
     */
    func reset(_ qubit: RegBit) throws {
        var condition: RegBit? = nil
        if let reg = self.creg {
            condition = reg
        }
        if !self.basis.contains("reset") {
            self.basis.append("reset")
            try self.circuit.add_basis_element("reset", 1)
        }
        try self.circuit.apply_operation_back("reset", [qubit], [], [], condition)
    }

    /**
     Attach a current condition.
     creg is a name string.
     cval is the integer value for the test.
     */
    func set_condition(_ creg: RegBit, _ cval: Int) {
        self.creg = creg
        self.cval = cval
    }

    /**
     Drop the current condition.
     */
    func drop_condition() {
        self.creg = nil
        self.cval = nil
    }

    /**
     Begin a custom gate.
     name is name string.
     args is list of floating point parameters.
     qubits is list of (regname, idx) tuples.
     */
    func start_gate(_ name: String, _ args: [Double], _ qubits: [RegBit]) throws {
        if self.listen && !self.basis.contains(name) {
            if let gate = self.gates[name] {
                if gate.opaque {
                    throw BackendException.erroropaque(name: name)
                }
            }
        }
        if self.listen && self.basis.contains(name) {
            var condition: RegBit? = nil
            if let reg = self.creg {
                condition = reg
            }
            self.in_gate = name
            self.listen = false
            try self.circuit.add_basis_element(name, qubits.count, 0, args.count)
            var params: [String] = []
            for arg in args {
                params.append(String(arg))
            }
            try self.circuit.apply_operation_back(name, qubits, [], params, condition)
        }
    }

    /**
     End a custom gate.
     name is name string.
     args is list of floating point parameters.
     qubits is list of (regname, idx) tuples.
     */
    func end_gate(_ name: String, _ args: [Double], _ qubits: [RegBit]) {
        if name == self.in_gate {
            self.in_gate = ""
            self.listen = true
        }
    }
}
