//
//  DroppableArea.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation
import SwiftUI

struct DroppableArea: View {
  @Binding var fileURL: URL?
  @State private var isActive: Bool = false
  @State private var isError: Bool = false

  var body: some View {
    let dropDelegate = P8DropDelegate(
      fileURL: $fileURL,
      active: $isActive,
      isError: $isError
    )

    return VStack(spacing: 0) {
      Rectangle()
        .fill(
          isError ? Color.red :
            (isActive ? Color.green : Color.gray)
        )
    }
    .onDrop(of: ["public.file-url"], delegate: dropDelegate)
    .onChange(of: isError) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        isError = false
      }
    }
  }
}

fileprivate struct P8DropDelegate: DropDelegate {
  @Binding var fileURL: URL?
  @Binding var active: Bool
  @Binding var isError: Bool

  func validateDrop(info: DropInfo) -> Bool {
    info.hasItemsConforming(to: ["public.file-url"])
  }

  func dropEntered(info: DropInfo) {
    /*do nothing*/
  }

  func performDrop(info: DropInfo) -> Bool {

    if let item = info.itemProviders(for: ["public.file-url"]).first {
      item.loadItem(
        forTypeIdentifier: "public.file-url",
        options: nil
      ) { (urlData, error) in
        DispatchQueue.main.async {

          if fileURL != nil {
            isError = true
          } else {

            if let urlData = urlData as? Data {
              let url = NSURL(
                absoluteURLWithDataRepresentation: urlData,
                relativeTo: nil
              ) as URL
              if url.lastPathComponent.contains("p8") == true {
                self.fileURL = url
                NSSound(named: "Submarine")?.play()
              } else {
                isError = true
              }
            }
          }
        }
      }

      return true

    } else {
      isError = true
      return false
    }
  }

  func dropUpdated(info: DropInfo) -> DropProposal? {
    active = true
    return nil
  }

  func dropExited(info: DropInfo) {
    active = false
  }
}
