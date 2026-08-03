import { defineComponent, h } from "vue"

export const BngButton = defineComponent({
  name: "BngButton",
  inheritAttrs: false,
  setup(_, { attrs, slots }) {
    return () => h("button", { ...attrs, type: attrs.type || "button" }, slots.default?.())
  },
})
