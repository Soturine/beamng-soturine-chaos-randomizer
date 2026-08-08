import { defineComponent, h, ref } from "vue"

export const BngButton = defineComponent({
  name: "BngButton",
  inheritAttrs: false,
  setup(_, { attrs, slots }) {
    return () => h("button", { ...attrs, type: attrs.type || "button" }, slots.default?.())
  },
})

export const BngSmartSelect = defineComponent({
  name: "BngSmartSelect",
  inheritAttrs: false,
  props: {
    modelValue: { default: "" },
    items: { type: Array, default: () => [] },
    disabled: { type: Boolean, default: false },
  },
  emits: ["update:modelValue", "change"],
  setup(props, { attrs, emit, expose }) {
    const open = ref(false)
    const openDropdown = () => { if (!props.disabled) open.value = true }
    const choose = item => {
      emit("update:modelValue", item.value)
      emit("change", item.value)
      open.value = false
    }
    expose({ openDropdown })
    return () => h("div", { class: "bng-smart-select-mock" }, [
      h("button", {
        ...attrs,
        type: "button",
        class: ["bng-smart-select-trigger", attrs.class],
        disabled: props.disabled,
        "aria-haspopup": "listbox",
        "aria-expanded": String(open.value),
        onClick: () => { open.value = !open.value },
        onKeydown: event => {
          if (event.key === "Escape") open.value = false
          if (event.key === "ArrowDown") openDropdown()
        },
      }, props.items.find(item => Object.is(item.value, props.modelValue))?.label || ""),
      open.value
        ? h("div", { class: "bng-smart-select-options", role: "listbox" }, props.items.map(item => h("button", {
          type: "button",
          role: "option",
          "aria-selected": String(Object.is(item.value, props.modelValue)),
          "data-value": String(item.value),
          onClick: () => choose(item),
        }, item.label)))
        : null,
    ])
  },
})
