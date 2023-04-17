//
//  EditSavedView.swift
//  swift-paperless
//
//  Created by Paul Gessinger on 16.04.23.
//

import SwiftUI

struct EditSavedView<S>: View where S: SavedViewProtocol {
    @Binding var outSavedView: S
    @State private var savedView: S
    var onSave: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    init(savedView: Binding<S>, onSave: @escaping () -> Void = {}) {
        self._outSavedView = savedView
        self._savedView = State(initialValue: savedView.wrappedValue)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: self.$savedView.name)
                        .clearable(self.$savedView.name)

                    Toggle("Show on dashboard", isOn: $savedView.showOnDashboard)

                    Toggle("Show in sidebar", isOn: $savedView.showInSidebar)
                }

                Section {
                    Picker("Sort by", selection: $savedView.sortField) {
                        ForEach(SortField.allCases, id: \.self) { v in
                            Text("\(v.label)").tag(v)
                        }
                    }

                    Toggle("Ascending", isOn: $savedView.sortReverse)
                }
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.dismiss()
                    }
                    .foregroundColor(.accentColor) // why is this needed? It's not elsewhere
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        outSavedView = savedView
                        onSave()
                        self.dismiss()
                    }
                    .disabled(savedView.name.isEmpty)
                    .bold()
                    .foregroundColor(.accentColor) // why is this needed? It's not elsewhere
                }
            }

            .navigationTitle("Saved view")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
}

struct EditSavedView_Previews: PreviewProvider {
    struct Container: View {
        @State var view = ProtoSavedView(name: "")
        var body: some View {
            EditSavedView(savedView: $view)
        }
    }

    static var previews: some View {
        Container()
    }
}
