<script lang="ts">
	import Clock from 'svelte-radix/Clock.svelte';
	import Heart from 'svelte-radix/Heart.svelte';

	let {
		slug,
		image,
		title,
		category,
		description,
		likes,
		readTime,
		published
	}: Omit<Post, 'tags'> = $props();
</script>

<a
	href="/posts/{slug}"
	class="border-surface-200-800 divide-surface-200-800 preset-filled-surface-100-900 block max-w-md divide-y overflow-hidden border-[1px]"
>
	<header>
		<img src={image} class="aspect-[21/9] w-full grayscale hue-rotate-90" alt="{title} cover" />
	</header>
	<article class="space-y-4 p-4">
		<div>
			<h2>{category}</h2>
			<h3>{title}</h3>
		</div>
		<p class="opacity-60">
			{description}
		</p>
	</article>
	<footer class="flex items-center justify-between gap-4 p-4">
		<small class="flex items-center gap-2 opacity-60">
			<span class="space-x-2">
				<Heart />
				{likes}
			</span>
			<span class="spacee-x-2">
				<Clock />
				{readTime} min read
			</span>
		</small>
		<small class="opacity-60">On {new Date(published).toISOString()}</small>
	</footer>
</a>
