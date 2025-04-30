//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//
import Foundation
import OpenTelemetryApi

public protocol IExporterMetrics {
    func addSeen(value: Int)
    func addSuccess(value: Int)
    func addFailed(value: Int)
}
