/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public protocol ContextPropagators {
  var textMapPropagator: TextMapPropagator { get }
  var textMapBaggagePropagator: TextMapBaggagePropagator { get }
}

extension OpenTelemetry {

    public static func registerDefaultPropagators() {
        self.registerPropagators(textPropagators: [W3CTraceContextPropagator()], baggagePropagator: W3CBaggagePropagator())
    }

    public static var propagators: ContextPropagators {
        instance._propagators as! ContextPropagators
    }

    public static func registerPropagators(textPropagators: [TextMapPropagator],
                                           baggagePropagator: TextMapBaggagePropagator) {
      instance._propagators = DefaultContextPropagators(textPropagators: textPropagators, baggagePropagator: baggagePropagator)
    }

}
